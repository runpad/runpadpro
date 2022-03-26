


template <int _pixels>
void CLayer::Smooth(int factor,int from_layer,int to_layer)
{
  if ( IsValid() )
     {
       const int numlayers = GetBPP() / 8;
       const int rowstride = GetRowStride();

       if ( from_layer < 0 || from_layer >= numlayers )
          from_layer = 0;

       if ( to_layer < 0 || to_layer >= numlayers )
          to_layer = numlayers-1;

       if ( from_layer <= to_layer )
          {
            for ( int level = 0; level < factor; level++ )
                {
                  for ( int m = 1; m < GetHeight() - 1; m++ )
                      {
                        BYTE *row = GetPointer(1,m);
                        
                        for ( int n = 1; n < GetWidth() - 1; n++ )
                            {
                              BYTE *p = row + from_layer; // start offset
                              int process_layers = to_layer - from_layer + 1;

                              do {
                                int c = 0;

                                if ( _pixels == 9 )
                                   {
                                     c += *(p-rowstride-numlayers) * 3;
                                     c += *(p-rowstride) * 4;
                                     c += *(p-rowstride+numlayers) * 3;
                                     c += *(p-numlayers) * 4;
                                     c += *(p) * 4;
                                     c += *(p+numlayers) * 4;
                                     c += *(p+rowstride-numlayers) * 3;
                                     c += *(p+rowstride) * 4;
                                     c += *(p+rowstride+numlayers) * 3;
                                     c >>= 5;
                                   }
                                else
                                if ( _pixels == 5 )
                                   {
                                     c += *(p-rowstride) * 1;
                                     c += *(p-numlayers) * 1;
                                     c += *(p) * 8;
                                     c += *(p+numlayers) * 1;
                                     c += *(p+rowstride) * 1;
                                     c = CTables::FastDiv12NotSafe(c); // c /= 12
                                   }

                                *p++ = c;
                              } while ( --process_layers );

                              row += numlayers;
                            }
                      }
                }
          }
     }
}

