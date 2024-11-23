class Cache:
    def __init__(self):
        print("@@@ cache > init")
        self.storage = {} 
    
    def get(self, params):
        print("@@@ cache > get" + " params: " + str(params))
        return self.storage.get(str(params), None)
    
    def set(self, params, response):
        print("@@@ cache > set " + " params: " + str(params) + " response: " + str(response))
        self.storage[str(params)] = response
