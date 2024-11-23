from flask import Flask, request, make_response

app = Flask(__name__)

@app.route('/recommand', methods=['GET'])
def recommand():
    description = request.args.get('description')
    if description:
        response_text = f"Received description: {description}"
        response = make_response(response_text)
        response.headers['Content-Type'] = 'text/html; charset=utf-8'
        return response
    else:
        return "Description parameter is missing.", 400


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)