class Cache:
    def __init__(self):
        print("cache init")
        return

    def get(self, params):
        print("cache get"+ "params: " + str(params))
        # params를 key로 해서
        # key value storage에서 값을 조회
        # 있으면 return 없으면 none return
        return None

    def set(self, params, response):
        print("cache set" + "params: " + str(params) + "response: " + str(response))
        # params를 key로 해서
        # key value storage에서 response를 저장
        return
