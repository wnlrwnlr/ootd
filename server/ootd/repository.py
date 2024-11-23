import requests

class Repository:
    def __init__(self, api_key):
        print("repositroy init" + "api_key: " + str(api_key))
        self.api_key = api_key

    def get(self, params):
        print("repository get" + "params: " + str(params))

        try:
            print(self.__request_chat(params))
        except ValueError as e:
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
                    "content": "너는 주어진 상황에 맞는 옷을 추천해주는 비서야"
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
            return "Response:", response.json()
        else:
            raise ValueError(response.status_code, response.text)
