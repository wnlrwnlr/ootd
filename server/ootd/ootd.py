from cache import Cache
from repository import Repository
import os
from dotenv import load_dotenv


class OOTD:
    def __init__(self):
        print("@@@ ootd > init")

        load_dotenv()
        api_key = os.getenv('API_KEY')

        self.cache = Cache()
        self.repository = Repository(api_key=api_key)

    def handle(self, params):
        print("@@@ ootd > handle" + " params: " + str(params))
        cached = self.cache.get(params=params)

        if cached:
            return cached
        else:
            response = self.repository.get(params=params)
            if response:
                self.cache.set(params=params, response=response)
            return response


ootd = OOTD()
result = ootd.handle("오늘 조금 춥고, 바람도 불고 캐쥬얼한 옷도 좋고 나는 남자야.")
result = ootd.handle("오늘 조금 춥고, 바람도 불고 캐쥬얼한 옷도 좋고 나는 남자야.")