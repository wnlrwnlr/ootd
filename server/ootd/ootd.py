from cache import Cache
from repository import Repository


class OOTD:
    def __init__(self, api_key):
        print("ootd init" + str(api_key))
        self.api_key = api_key
        self.cache = Cache()
        self.repository = Repository(api_key=api_key)

    def handle(self, params):
        print("ootd handle" + str(params))
        cached = self.cache.get(params=params)

        if cached:
            return cached
        else:
            response = self.repository.get(params=params)
            if response:
                self.cache.set(params=params, response=response)
            return response


ootd = OOTD(123)
ootd.handle("hello world")
