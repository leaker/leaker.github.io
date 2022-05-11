---
title: python的zlib压缩解压缩对应的C语言方式
tags:
  - c
  - compress
  - decompress
  - python
  - zlib
id: 446
categories:
  - programing
date: 2013-07-02T15:47:00+08:00
---

# 压缩
```python
enData = zlib.compress(data)[2:-4]
```
对应：
```c
compress2(dstbuf, &dstLen, strSrc, srcLen, 6);
```

# 解压
```python
deData = zlib.decompress(enData, -zlib.MAX_WBITS)
```
对应：
```c
bool gzipInflate( const std::string& compressedBytes, std::string& uncompressedBytes ) {
    if ( compressedBytes.size() == 0 ) {
        uncompressedBytes = compressedBytes ;
        return true ;
    }

    uncompressedBytes.clear() ;

    unsigned full_length = compressedBytes.size() ;
    unsigned half_length = compressedBytes.size() / 2;

    unsigned uncompLength = full_length ;
    char* uncomp = (char*) calloc( sizeof(char), uncompLength );

    z_stream strm;
    strm.next_in = (Bytef *) compressedBytes.c_str();
    strm.avail_in = compressedBytes.size() ;
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;

    bool done = false ;

    //if (inflateInit2(&strm, (16+MAX_WBITS)) != Z_OK)
    if (inflateInit2(&strm, -MAX_WBITS) != Z_OK)
    {
        free( uncomp );
        return false;
    }

    while (!done) {
        // If our output buffer is too small
        if (strm.total_out >= uncompLength ) {
            // Increase size of output buffer
            char* uncomp2 = (char*) calloc( sizeof(char), uncompLength + half_length );
            memcpy( uncomp2, uncomp, uncompLength );
            uncompLength += half_length ;
            free( uncomp );
            uncomp = uncomp2 ;
        }

        strm.next_out = (Bytef *) (uncomp + strm.total_out);
        strm.avail_out = uncompLength - strm.total_out;

        // Inflate another chunk.
        int err = inflate (&strm, Z_SYNC_FLUSH);
        if (err == Z_STREAM_END) done = true;
        else if (err != Z_OK)  {
            break;
        }
    }

    if (inflateEnd (&strm) != Z_OK) {
        free( uncomp );
        return false;
    }

    for ( size_t i=0; i<strm.total_out; ++i ) {
        uncompressedBytes += uncomp[ i ];
    }
    free( uncomp );
    return true ;
}
```
