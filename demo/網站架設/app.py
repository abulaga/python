from flask import Flask
app2=Flask(__name__) #__name__ 代表目前執行模組

@app2.route("/") #函式的裝飾(Decorator):已函式為基礎，提供附加的功能
def home():
    return "Hello Flask 123"

@app2.route("/test")
def test():
    return "This is test"

if __name__=="__main__":    #如果是主程式就執行
    app2.run()   #立刻啟動伺服器