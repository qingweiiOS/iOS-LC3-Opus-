# **iOS opus 和 lc3 的编译**
## **opus编译**

1. 克隆源码(也可以去这个连接下载指定的版本):

    ``` shell
    git clone https://gitlab.xiph.org/xiph/opus
    ```

2. 在根目录下创建 `build` 文件夹

    ```shell
    cd opus
    mkdir build
    cd build
    ```

3. 交叉编译

     ```shell
    cmake .. -G "Unix Makefiles" -DCMAKE_SYSTEM_NAME=iOS -DCMAKE_OSX_ARCHITECTURES=arm64
    ```

4. 构建 Opus 库:
    ```shell
    cmake --build .
    ```

5. 得到库文件和头文件: 头文件在 `include`文件夹中，`.a` 文件在`build`文件夹中





## **LC3编译**

1. 修改`MakeFile` 

    > 将这两句注释中间的内容 (在`MakeFile`文件内容的开头位置)
    > ```
    > #
    > # Set `gcc` as default compiler
    > #
    > 
    > 需要被替换的内容
    > 
    > #
    > # Declarations
    > #
    > 
    > ```
    > 替换为
    >    ``` 
    >    CC := xcrun -sdk iphoneos clang -arch arm64
    >    ```
   
    > 将以下代码(在`MakeFile`文件内容的末尾位置)
    > ```
    > $(LIB): $(MAKEFILE_DEPS)
    > 	@echo "  LD      $(notdir $@)"
    > 	$(V)mkdir -p $(dir $@)
    > 	$(V)$(LD) $(filter %.o,$^) $(LDFLAGS) -o $@
    > ```
    > 替换为
    > ```
    > $(LIB): $(MAKEFILE_DEPS)
    > 	@echo "  AR      $(notdir $@)"
    > 	$(V)mkdir -p $(dir $@)
    > 	$(V)$(AR) rcs $@ $(filter %.o,$^)
    > ```

2. 使用终端编译：CD到源码根目录 ，执行编译操作 
```
make -j
```
3. 得到库文件和头文件: 头文件在 `include`文件夹中，`.a` 文件在`build`文件夹中

