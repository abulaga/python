import sys #載入內建的 sys 模組並取得資訊
print(sys.platform)
print(sys.maxsize)

#直接呼叫
import c2_被載入模組 as mod
result = mod.distance(1,1,5,5)
print(result)

#若該模組放在不同資料夾內，需調整搜尋模組路徑
#print(sys.path)    模組搜尋路徑
sys.path.append("c2_被載入模組資料夾")  #在模組搜尋路徑中新增路徑
import c2_被載入模組資料夾.c3_被載入模組 as mod2
result = mod.slope(1,2,5,6)
print(result)