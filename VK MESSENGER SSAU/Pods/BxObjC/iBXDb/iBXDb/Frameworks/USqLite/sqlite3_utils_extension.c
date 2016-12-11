//
//  bx_unicode_sqlite3_utils_extension.c
//  iBXData
//
//  Created by Sergan on 03.10.13.
//  Copyright (c) 2013 ByteriX. All rights reserved.
//

#include <stdio.h>
#import <math.h>
#import "bx_unicode_sqlite3.h"

#define DEG2RAD(degrees) (degrees * 0.01745327) // degrees * pi over 180

static void distanceFunc(bx_unicode_sqlite3_context *context, int argc, bx_unicode_sqlite3_value **argv)
{
    // check that we have four arguments (lat1, lon1, lat2, lon2)
    //assert(argc == 4);
    // check that all four arguments are non-null
    if (bx_unicode_sqlite3_value_type(argv[0]) == SQLITE_NULL || bx_unicode_sqlite3_value_type(argv[1]) == SQLITE_NULL || bx_unicode_sqlite3_value_type(argv[2]) == SQLITE_NULL || bx_unicode_sqlite3_value_type(argv[3]) == SQLITE_NULL) {
        bx_unicode_sqlite3_result_null(context);
        return;
    }
    // get the four argument values
    double lat1 = bx_unicode_sqlite3_value_double(argv[0]);
    double lon1 = bx_unicode_sqlite3_value_double(argv[1]);
    double lat2 = bx_unicode_sqlite3_value_double(argv[2]);
    double lon2 = bx_unicode_sqlite3_value_double(argv[3]);
    // convert lat1 and lat2 into radians now, to avoid doing it twice below
    double lat1rad = DEG2RAD(lat1);
    double lat2rad = DEG2RAD(lat2);
    // apply the spherical law of cosines to our latitudes and longitudes, and set the result appropriately
    // 6378.1 is the approximate radius of the earth in kilometres
    double result = acos(sin(lat1rad) * sin(lat2rad) + cos(lat1rad) * cos(lat2rad) * cos(DEG2RAD(lon2) - DEG2RAD(lon1))) * 6378.1;
    bx_unicode_sqlite3_result_double(context, result);
}

void bx_unicode_sqlite3_utils_extension_init(bx_unicode_sqlite3 *db)
{
    bx_unicode_sqlite3_create_function(db, "distance", 4, SQLITE_UTF8, NULL, &distanceFunc, NULL, NULL);
}

void bx_unicode_sqlite3_utils_extension_load()
{
    bx_unicode_sqlite3_auto_extension((void*)bx_unicode_sqlite3_utils_extension_init);
}