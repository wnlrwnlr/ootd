import requests
import sentry_sdk


class Repository:
    def __init__(self, api_key):
        print("@@@ repositroy > init" + " api_key: " + str(api_key))
        self.api_key = api_key

    def get(self, params):
        print("@@@ repository get > " + " params: " + str(params))
        sentry_sdk.capture_message(f"Handling request with params: {params}")

        try:
            description = self.__request_chat(params)
            image = self.__request_image(description)
            return description, image
        except ValueError as e:
            sentry_sdk.capture_exception(e)
            print(e)
            return None

    def __request_chat(self, parms):
        # API URL 및 헤더 설정

        url = "https://api.openai.com/v1/chat/completions"

        headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {self.api_key}"
        }

        # 요청 데이터 설정
        data = {
            "model": "gpt-4o-mini",
            "messages": [
                {
                    "role": "system",
                    "content": "너는 주어진 상황에 맞는 옷을 추천해주는 비서야. 주어진 상황에 대해 의상 추천을 간결하게 해줘. 앞뒤에 사족을 붙이지 마."
                },
                {
                    "role": "user",
                    "content": f"{parms}"
                }
            ]
        }

        # POST 요청 보내기
        response = requests.post(url, headers=headers, json=data)

        # 응답 반환
        if response.status_code == 200:
            return response.json()["choices"][0]["message"]["content"]
        else:
            raise ValueError(response.status_code, response.text)

    def __request_image(self, description):
        print(description)

        # API URL 및 헤더 설정
        url = "https://api.openai.com/v1/images/generations"
        headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {self.api_key}"
        }

        # 요청 데이터 설정
        data = {
            "model": "dall-e-3",
            "prompt": f"의상을 추천해주는 비서로부터 {description} 라는 대답을 들었어. 어떤 의상인지 상상이 되지 않는데 의상의 생김새를 묘사해줘.",
            "n": 1,
            "size": "1024x1024"
        }

        # POST 요청 보내기
        response = requests.post(url, headers=headers, json=data)

        # 응답 반환
        if response.status_code == 200:
            return response.json()["data"][0]["url"]
        else:
            raise ValueError(response.status_code, response.text)

