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
- 安装 Ninja **v1.10.2**
- 安装 Python **v3.10.4** 和 Numpy
- 安装 wget **1.21.3**
- 安装 7zip **21.07**
- 安装 Cuda SDK **v11.7**
- 一键下载 OpenCV **4.5.5** 源码并编译
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

# 安装 Ninja **v1.10.2**
```bat
scoop install ninja@1.10.2
```

# 安装 Python **v3.10.4** 和 Numpy
```bat
scoop install python@3.10.4
pip install numpy
```

# 安装 wget **1.21.3**
```bat
scoop install wget@1.21.3
```

# 安装 7zip **21.07**
```bat
scoop install 7zip@21.07
```


# 安装 Cuda SDK
安装流程： https://docs.nvidia.com/cuda/cuda-installation-guide-microsoft-windows/index.html#installing-cuda-development-tools

# 一键下载 opencv **4.5.5** 源码并编译
*download_and_build_opencv.bat*
```bat
@ECHO OFF
ECHO -- Downloading OpenCV Source Code --
wget https://github.com/opencv/opencv/archive/refs/tags/4.5.5.zip -O opencv-4.5.5.zip
IF NOT ERRORLEVEL 0 GOTO :end
7z x opencv-4.5.5.zip
IF NOT ERRORLEVEL 0 GOTO :end
wget https://github.com/opencv/opencv_contrib/archive/refs/tags/4.5.5.zip -O opencv_contrib-4.5.5.zip
IF NOT ERRORLEVEL 0 GOTO :end
7z x opencv_contrib-4.5.5.zip
IF NOT ERRORLEVEL 0 GOTO :end
SET OPENCV_SRC_DIR=%cd%/opencv-4.5.5
SET OPENCV_CONTRIB_SRC_DIR=%cd%/opencv_contrib-4.5.5
SET OPENCV_BUILD_DIR=%cd%/opencv-build
SET SCOOP_ROOT=%USERPROFILE%/scoop
SET CUDA_SDK_DIR="C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v11.7"
@REM CUDA_ARCH=8.6 for GeForce RTX 3080 Ti
@REM Choice value for your GPU with: https://developer.nvidia.com/cuda-gpus
SET CUDA_ARCH=8.6
ECHO -- Starting OpenCV Configuration --
call "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Auxiliary/Build/vcvars64.bat"
@REM If you want to use the Visual Studio 2019 MSVC:
@REM call "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Auxiliary/Build/vcvars64.bat" -vcvars_ver=14.29
call cmake.exe ^
-S%OPENCV_SRC_DIR% ^
-B%OPENCV_BUILD_DIR% ^
-DCMAKE_INSTALL_PREFIX=%OPENCV_BUILD_DIR%/install ^
-DOPENCV_EXTRA_MODULES_PATH=%OPENCV_CONTRIB_SRC_DIR%/modules ^
-DPYTHON3_EXECUTABLE=%SCOOP_ROOT%/apps/python/current/python.exe ^
-DPYTHON3_INCLUDE_DIR=%SCOOP_ROOT%/apps/python/current/include ^
-DPYTHON3_LIBRARY=%SCOOP_ROOT%/apps/python/current/libs/python310.lib ^
-DPYTHON3_NUMPY_INCLUDE_DIRS=%SCOOP_ROOT%/apps/python/current/Lib/site-packages/numpy/core/include ^
-DPYTHON3_PACKAGES_PATH=%SCOOP_ROOT%/apps/python/current/Lib/site-packages ^
-DPYTHON_INCLUDE_DIRS=%SCOOP_ROOT%/apps/python/current/include ^
-DPYTHON_LIBRARIES=%SCOOP_ROOT%/apps/python/current/libs/python310.lib ^
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
-DBUILD_opencv_python3=ON ^
-DCMAKE_CONFIGURATIONS_TYPES=Release ^
-DCMAKE_BUILD_TYPE=Release ^
-DOPENCV_PYTHON3_VERSION=3.10 ^
-DBUILD_TESTS=OFF ^
-DBUILD_PERF_TESTS=OFF ^
-DBUILD_JAVA=OFF ^
-DBUILD_opencv_objc_bindings_generator=OFF ^
-DBUILD_opencv_js=OFF ^
-GNinja ^
-DBUILD_opencv_world=ON
IF NOT ERRORLEVEL 0 GOTO :end
ECHO -- OpenCV Configuration has finished, press any key to proceeding to build phase... --
PAUSE
call cmake.exe --build %OPENCV_BUILD_DIR% --target install
ECHO -- OpenCV Build has finished, press any key to exit... --
PAUSE
:end
```
点我下载：[download_and_build_opencv.bat](/files/2022/05/download_and_build_opencv.bat)

# 部署
将编译成功后的目录 **%OPENCV_BUILD_DIR%/install/x64/vc17/bin** 下的：
- opencv_img_hash455.dll
- opencv_videoio_ffmpeg455_64.dll
- opencv_world455.dll
拷贝到 Windows 的 **%PATH%** 目录，例如： **%SCOOP_ROOT%/apps/python/current/Scripts**

# 测试 OpenCV
```bat
python -c "import cv2; print(cv2.__version__); print(cv2.cuda.getCudaEnabledDeviceCount())"
```