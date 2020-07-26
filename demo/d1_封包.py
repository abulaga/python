#基本上一個檔案就是一個模組(module)
#而封包的用途就是把多個模組打包成一個封包(package)

#封包資料夾必包含一個【__init__.py】的檔案，才會被當成一個封包
import d2_被載入封包.point
result = d2_被載入封包.point.distance(3,4)
print("距離",result)

import d2_被載入封包.line as line
result = line.slope(1,1,3,3)
print("斜率",result)