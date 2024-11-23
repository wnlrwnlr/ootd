from cache import Cache
from repository import Repository
import os
from dotenv import load_dotenv


class Handler:
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
