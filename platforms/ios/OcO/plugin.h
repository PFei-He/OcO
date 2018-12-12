//
//  Copyright (c) 2018 faylib.top
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#ifndef plugin_h
#define plugin_h

#if Debug

// Device Plugin
#define debug_mode debug_mode
#define load_information load_information
#define free_size free_size
#define store_size store_size

// Network Plugin
#define debug_mode debug_mode
#define timeout_interval timeout_interval
#define retry_times retry_times
#define set_headers set_headers
#define request_get request_get
#define request_post request_post
#define request_delete request_delete
#define request_download request_download
#define reset_request reset_request
#define start_monitoring start_monitoring
#define stop_monitoring stop_monitoring
#define network_reachability network_reachability

#else

// Device Plugin
#define debug_mode debug_mode
#define load_information load_information
#define free_size free_size
#define store_size store_size

// Network Plugin
#define debug_mode debug_mode
#define timeout_interval timeout_interval
#define retry_times retry_times
#define set_headers set_headers
#define request_get request_get
#define request_post request_post
#define request_delete request_delete
#define request_download request_download
#define reset_request reset_request
#define start_monitoring start_monitoring
#define stop_monitoring stop_monitoring
#define network_reachability network_reachability

#endif

#endif /* plugin_h */
