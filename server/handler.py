from cache import Cache
from repository import Repository
import os
from dotenv import load_dotenv
import sentry_sdk


class Handler:
    def __init__(self):
        sentry_sdk.capture_message("Handler initialized")

        load_dotenv()
        api_key = os.getenv('API_KEY')

        self.cache = Cache()
        self.repository = Repository(api_key=api_key)

    def handle(self, params):
        sentry_sdk.capture_message(f"Handling request with params: {params}")

        try:
            cached = self.cache.get(params=params)

            if cached:
                sentry_sdk.capture_message("Cache hit")
                return cached
            else:
                sentry_sdk.capture_message("Cache miss")
                response = self.repository.get(params=params)
                if response:
                    self.cache.set(params=params, response=response)
                return response

        except Exception as e:
            sentry_sdk.capture_exception(e)
            raise e
