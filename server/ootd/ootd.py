from cache import Cache

class OOTD:
    def __init__(self, api_key):
        self.api_key = api_key
        self.cache = Cache()

    def handle(self, params):
        print(params)
        print(self.api_key)

        cached = self.cache.get(params)

        if cached:
            return cached
        else:
            # api 호출
            return
        
ootd = OOTD(123)
ootd.handle("hello world")