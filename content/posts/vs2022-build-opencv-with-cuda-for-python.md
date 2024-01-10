---
title: 使用 Visual Studio 2022 为 python 编译 OpenCV 加 CUDA 支持
date: 2022-05-14T09:59:11+08:00
categories:
  - programing
tags:
---

# 准备工作
- 安装 Scoop
- 安装 Visual Studio 2022
- 安装 Ninja **v1.11.1**
- 安装 Python **v3.10** 和 Numpy
- 安装 wget 和 7zip
- 安装 Cuda SDK **v11.7**
- 一键下载 OpenCV **4.6.0** 源码并编译
- 部署
- 测试 OpenCV

# 安装 Scoop
打开 **PowerShell** 后执行：
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-WebRequest get.scoop.sh | Invoke-Expression
```
安装参考： <https://scoop.sh>

# 安装 Visual Studio 2022
1. 从 <https://visualstudio.microsoft.com> 下载你喜欢的版本，推荐免费的 **Community** 版本
2. 安装 **使用C++的桌面开发** 工作负荷
   > 使用所选工具(包括 MSVC、CLang、CMake 或 MSBuild)生成适用于 Windows 的现代 C++ 应用

# 安装 Ninja **v1.11.1**
```bat
scoop install ninja@1.11.1
```

# 安装 Python **v3.10** 和 Numpy
```bat
scoop bucket add versions
scoop install python310
pip install numpy
```

# 安装 wget 和 7zip
```bat
scoop install wget 7zip
```


# 安装 Cuda SDK  **v11.7**
安装流程： https://docs.nvidia.com/cuda/cuda-installation-guide-microsoft-windows/index.html#installing-cuda-development-tools

# 一键下载 opencv **4.6.0** 源码并编译
*download_and_build_opencv.bat*
```bat
@ECHO OFF
ECHO -- Downloading OpenCV Source Code --
wget https://github.com/opencv/opencv/archive/refs/tags/4.6.0.zip -O opencv-4.6.0.zip
IF %ERRORLEVEL% NEQ 0 GOTO :error
7z x -y opencv-4.6.0.zip
IF %ERRORLEVEL% NEQ 0 GOTO :error
wget https://github.com/opencv/opencv_contrib/archive/refs/tags/4.6.0.zip -O opencv_contrib-4.6.0.zip
IF %ERRORLEVEL% NEQ 0 GOTO :error
7z x -y opencv_contrib-4.6.0.zip
IF %ERRORLEVEL% NEQ 0 GOTO :error
SET "USERHOME=%USERPROFILE:\=/%"
SET OPENCV_SRC_DIR=%cd%/opencv-4.6.0
SET OPENCV_CONTRIB_SRC_DIR=%cd%/opencv_contrib-4.6.0
SET OPENCV_BUILD_DIR=%cd%/opencv-build
SET SCOOP_ROOT=%USERHOME%/scoop
SET PYTHON_PATH=%SCOOP_ROOT%/apps/python310/current
SET PYTHON_LIBRARY=%PYTHON_PATH%/libs/python310.lib
SET PYTHON_VERSION=3.10
SET CUDA_SDK_DIR="C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v11.7"
@REM CUDA_ARCH=8.6 for GeForce RTX 3080 Ti
@REM Choice value for your GPU with: https://developer.nvidia.com/cuda-gpus
SET CUDA_ARCH=8.6
ECHO -- Starting OpenCV Configuration --
call "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Auxiliary/Build/vcvars64.bat"
@REM If you want to use the Visual Studio 2019 MSVC:
@REM call "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Auxiliary/Build/vcvars64.bat" -vcvars_ver=14.29
cmake ^
-S%OPENCV_SRC_DIR% ^
-B%OPENCV_BUILD_DIR% ^
-DCMAKE_INSTALL_PREFIX=%OPENCV_BUILD_DIR%/install ^
-DOPENCV_EXTRA_MODULES_PATH=%OPENCV_CONTRIB_SRC_DIR%/modules ^
-DPYTHON3_EXECUTABLE=%PYTHON_PATH%/python.exe ^
-DPYTHON3_INCLUDE_DIR=%PYTHON_PATH%/include ^
-DPYTHON3_LIBRARY=%PYTHON_LIBRARY% ^
-DPYTHON3_NUMPY_INCLUDE_DIRS=%PYTHON_PATH%/Lib/site-packages/numpy/core/include ^
-DPYTHON3_PACKAGES_PATH=%PYTHON_PATH%/Lib/site-packages ^
-DPYTHON_INCLUDE_DIRS=%PYTHON_PATH%/include ^
-DPYTHON_LIBRARIES=%PYTHON_LIBRARY% ^
-DCUDA_TOOLKIT_ROOT_DIR=%CUDA_SDK_DIR% ^
-DENABLE_FAST_MATH=ON ^
-DCUDA_FAST_MATH=ON ^
-DWITH_CUDA=ON ^
-DWITH_CUDNN=ON ^
-DOPENCV_DNN_CUDA=ON ^
-DCUDA_ARCH_BIN=%CUDA_ARCH% ^
-DCUDA_ARCH_PTX=%CUDA_ARCH% ^
-DWITH_OPENGL=ON ^
-DWITH_GSTREAMER=ON ^
-DWITH_FREETYPE=ON ^
-DBUILD_opencv_python3=ON ^
-DCMAKE_CONFIGURATIONS_TYPES=Release ^
-DCMAKE_BUILD_TYPE=Release ^
-DOPENCV_PYTHON3_VERSION=%PYTHON_VERSION% ^
-DBUILD_TESTS=OFF ^
-DBUILD_PERF_TESTS=OFF ^
-DBUILD_JAVA=OFF ^
-DBUILD_opencv_objc_bindings_generator=OFF ^
-DBUILD_opencv_js=OFF ^
-GNinja ^
-DBUILD_opencv_world=ON
IF %ERRORLEVEL% NEQ 0 GOTO :error
ECHO -- OpenCV Configuration has finished, press any key to proceeding to build phase... --
PAUSE > NUL
cmake --build %OPENCV_BUILD_DIR% --target install
IF %ERRORLEVEL% NEQ 0 GOTO :error
ECHO -- OpenCV Build has finished, press any key to install... --
PAUSE > NUL
pip uninstall opencv-python opencv-contrib-python
IF %ERRORLEVEL% NEQ 0 GOTO :error
COPY %OPENCV_BUILD_DIR%/lib/python3/cv2.cp310-win_amd64.pyd %PYTHON_PATH%/Lib/site-packages/cv2.cp310-win_amd64.pyd /Y
IF %ERRORLEVEL% NEQ 0 GOTO :error
COPY %OPENCV_BUILD_DIR%/install/x64/vc17/bin/*.dll %PYTHON_PATH%/Scripts /Y
IF %ERRORLEVEL% NEQ 0 GOTO :error
pip install opencv-contrib-python
IF %ERRORLEVEL% NEQ 0 GOTO :error
ECHO -- all finished, press any key to exit... --
PAUSE > NUL
GOTO :EOF

:error
ECHO -- Error has occurred!!! press any key to exit... --
PAUSE > NUL
```
点我下载：[download_and_build_opencv.bat](/files/2022/05/download_and_build_opencv.bat)

# 部署
1. 卸载 **opencv-python opencv-contrib-python**
2. 拷贝 **%OPENCV_BUILD_DIR%/lib/python3/cv2.cp310-win_amd64.pyd** 到 **%PYTHON_PATH%/Lib/site-packages** 目录
3. 拷贝 **%OPENCV_BUILD_DIR%/install/x64/vc17/bin/*.dll** 到 Windows 的 **%PATH%** 目录 或者 **%PYTHON_PATH%/Scripts** 目录
4. 重新安装 **opencv-contrib-python**
```bat
pip uninstall opencv-python opencv-contrib-python
COPY %OPENCV_BUILD_DIR%/lib/python3/cv2.cp310-win_amd64.pyd %PYTHON_PATH%/Lib/site-packages/cv2.cp310-win_amd64.pyd /Y
COPY %OPENCV_BUILD_DIR%/install/x64/vc17/bin/*.dll %PYTHON_PATH%/Scripts /Y
pip install opencv-contrib-python
```

# 测试 OpenCV
```bat
python -c "import cv2; print(cv2.__version__); print(cv2.cuda.getCudaEnabledDeviceCount())"
```