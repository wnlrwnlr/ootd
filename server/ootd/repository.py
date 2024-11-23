class Repository:
    def __init__(self, api_key):
        print("repositroy init" + "api_key: " + str(api_key))
        self.api_key = api_key

    def get(self, params):
        print("repository get" + "params: " + str(params))

        # params를 이용해서
        # 적절히 openAI api를 호출해서
        # 추천값을 받아와서 return
        return None
