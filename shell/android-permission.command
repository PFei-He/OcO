#
# Copyright (c) 2018 faylib.top
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

# 为 Android 工程获得权限
sudo chmod -R a+rwx ../

# 进入 Gradle 目录
cd /Applications/Android\ Studio.app/Contents/gradle/

# 找出所有的 Gradle 构建包
for gradle in `find . -name gradle-*`
do
	# 为 Android 工程获得使用 Gradle 的权限
	sudo chmod 755 $gradle/bin/gradle
done

# 退出脚本
exit 0
