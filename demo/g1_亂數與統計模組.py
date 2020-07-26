#隨機模組
import random

# 從列表中隨機選取 1 個資料
data=random.choice([1,5,6,10,20])

# 從列表中隨機選取 3 個資料
data=random.sample([1,5,6,10,20],3)

# 將列表的資料「就地」隨機調換順序
data = [1,2,5,8]
random.shuffle(data)    #洗牌

# 取得 0.0 ~ 1.0 之間的隨機亂數
data=random.random()
# 取得指定範圍隨機亂數
data=random.uniform(60, 100)
print(data)

# 取得平均數 100、標準差 10 的常態分配亂數 
data=random.normalvariate(100,10)   
# print(data)


import statistics as stat
# 計算列表中數字的平均數
data= stat.mean([1,5,6,9]) 
# 計算列表中數字的中位數 
data= stat.median([1,5,6,9])    
# 計算列表中數字的標準差
data = stat.stdev([1,5,6,9]) 
print(data)