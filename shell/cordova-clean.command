#
# Created by Fay on 2018/03/05.
#
# Copyright (c) 2018 saturn.xyz
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

#!/bin/bash

# 进入 Shell 脚本所在目录
path=$(dirname $_)
path=${path/\./$(pwd)}
cd $path

# 进入 Cordova 目录（工程根目录）
cd ../

# 清理已生成的包文件
cordova clean

# 删除残留文件和文件夹
rm -rf platforms/android/android.iml
rm -rf platforms/android/build/
rm -rf platforms/android/local.properties
rm -rf platforms/android/.idea/
rm -rf platforms/android/.gradle/
rm -rf .DS_Store
rm -rf web/.idea/
rm -rf www/index.html
rm -rf www/static/

# 退出脚本
exit 0
