import json
from flask import Flask, request, make_response
from handler import Handler
import sentry_sdk
from flask import Flask
import os


sentry_dsn = os.getenv("SENTRY_DSN")
sentry_sdk.init(
    dsn=sentry_dsn,
    traces_sample_rate=0.1,
    _experiments={
        "continuous_profiling_auto_start": True,
    },
)


app = Flask(__name__)

handler = Handler()


@app.route('/recommand', methods=['GET'])
def recommand():
    description = request.args.get('description')
    if description:
        result = handler.handle(description)

        if result is None:
            response_body = json.dumps({
                "status": "error",
                "message": "Handler failed to process the description."
            }, ensure_ascii=False)
            status_code = 500
        else:
            response_body = json.dumps({
                "status": "success",
                "description": result[0],
                "image": result[1]
            }, ensure_ascii=False)
            status_code = 200

        response = make_response(response_body, status_code)
        response.headers['Content-Type'] = 'application/json; charset=utf-8'
        return response
    else:
        response_body = json.dumps({
            "status": "error",
            "message": "Description parameter is missing."
        }, ensure_ascii=False)
        response = make_response(response_body, 400)
        response.headers['Content-Type'] = 'application/json; charset=utf-8'
        return response


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)