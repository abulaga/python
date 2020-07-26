# 判斷式(if)
x=input("請輸入數字: ")  #取得使用者輸入字串
x=int(x)    #轉換成數字
if x>100:
    print(">100")
elif x>50:
    print("x>50")
else:
    print("<=50")

#====================函式=======================================
#函式宣告
def divide(n1,n2=1):    #預設值
     print(n1/n2)

#不定參數
# def 函式名稱(*無限參數):
def avg(*ns):
    sum = 0
    for n in ns:
        sum += n
    print(sum/len(ns))

#====================迴圈=======================================
# while
n=0
while n<5:
    if n==3:
        break   #終止迴圈
    print(n)
    n+=1
print("最後的n:",n)

# for
n=0
for x in [0,1,2,3]: #逐一取得List內容
    if x%2==0:
        continue    #進入下一次迴圈
    print(x)
    n+=1
print("最後的n",n)

# else     
sum=0
for n in range(3):  #產生一個List [0,1,2]       range(3, 6)=>[3,4,5]
    sum+=n
    break   #break 不會觸發else
else:   #迴圈結束時執行
    print(sum)
