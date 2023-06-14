#（图片还不会放，markdown还不太会用，先这样吧）
在Quartus里面新建工程，注意工程名字一定要和.v文件的顶层模块名一样

根据芯片技术手册选择对应数据，这里选择如图所示，next

仿真工具选择ModelSim（如果是ModelSim-Altera则选择对应的），格式选择Verilog HDL，next-finish，工程新建完毕。
接下来将SPI协议进行编译

新建Verilog HDL File，将.v文件代码复制进来，ctrl+s保存

文件名和顶层模块名一致，后缀.v，文件类型如图，再进行编译：

出现图示界面并显示0error是，表示编译成功！
接下来编写testbench，注意，不能新建.v文件进行编写，会读取不到，这里先使用自动生成的testbench的模板

点了之后会在工程文件夹里看到（路径"SPI_test\simulation\modelsim\SPI.vt"）SPI.vt文件，双击打开

接下来进行复写，把你自己的testbench复制粘贴过去，但是注意，自动生成的顶层模块名不能改变，即“SPI_vlg_tst”不能变，复写之后保存关闭
接下来进行仿真设置






全部ok即可
接下来直接联合仿真


成功！
