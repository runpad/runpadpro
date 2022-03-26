/////////////////////////////////////////////////////////////////////////
// Файл				: giveio.h
// Описание			: Драйвер определения температуры процессора и чипсета
// OS				: Windows NT 
// Среда исполнения : KERNEL MODE
/////////////////////////////////////////////////////////////////////////

#include "giveio.h"

typedef char* IOPM; 
#define IOPM_SIZE 0x2000

IOPM g_local_iopm = NULL;

void __stdcall SetIOPermissionMap(ULONG OnFlag)
{
    Ke386IoSetAccessProcess((PVOID)IoGetCurrentProcess(), OnFlag);
    Ke386SetIoAccessMap(1, g_local_iopm);
}

void __stdcall GIVEIO_proc(void)
{
   SetIOPermissionMap(1);
}


NTSTATUS
CreateCloseDispatch(
         IN  PDRIVER_OBJECT DriverObject,
         IN  PIRP pIrp)
{
	GIVEIO_proc();
	pIrp->IoStatus.Status = 0;
	pIrp->IoStatus.Information = STATUS_SUCCESS;
    IoCompleteRequest(pIrp, IO_NO_INCREMENT);
    return STATUS_SUCCESS;
}

NTSTATUS
ADriverUnload(
         IN  PDRIVER_OBJECT DriverObject)
{
	UNICODE_STRING          ntDeviceName;
	
	MmFreeNonCachedMemory(g_local_iopm, IOPM_SIZE);
	RtlInitUnicodeString(&ntDeviceName, DOS_DEVICE_NAME);
	IoDeleteSymbolicLink(&ntDeviceName);
	IoDeleteDevice(DriverObject->DeviceObject);
}


NTSTATUS
DriverEntry(
    IN PDRIVER_OBJECT  DriverObject,
    IN PUNICODE_STRING RegistryPath
    )
{
	NTSTATUS                status = STATUS_SUCCESS;
    UNICODE_STRING          ntDeviceName;
	UNICODE_STRING          ntDosDeviceName;
	PDEVICE_OBJECT          deviceObject = NULL;

	g_local_iopm = MmAllocateNonCachedMemory(IOPM_SIZE);
	if(!g_local_iopm) return STATUS_INSUFFICIENT_RESOURCES;
	RtlZeroMemory(g_local_iopm, IOPM_SIZE);
	
	RtlInitUnicodeString(&ntDeviceName, GPD_DEVICE_NAME);

	status = IoCreateDevice (DriverObject,
                             0,
                             &ntDeviceName,
                             FILE_DEVICE_UNKNOWN,
                             0,
                             FALSE,
                             &deviceObject);

    
    if (!NT_SUCCESS (status)) {
        return status;
    }
	
	RtlInitUnicodeString(&ntDosDeviceName, DOS_DEVICE_NAME);

    status = IoCreateSymbolicLink( &ntDosDeviceName, &ntDeviceName );

    if (!NT_SUCCESS(status))    
    {                           
        IoDeleteDevice(deviceObject);
        return status;
    }

	DriverObject->DriverUnload = ADriverUnload;
	DriverObject->MajorFunction[IRP_MJ_CREATE] = CreateCloseDispatch;

    return STATUS_SUCCESS;
}



