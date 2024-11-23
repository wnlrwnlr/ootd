from flask import Flask, request, jsonify, make_response
from handler import Handler

app = Flask(__name__)

handler = Handler()

@app.route('/recommand', methods=['GET'])
def recommand():
    description = request.args.get('description')
    if description:
        result = handler.handle(description)

        if result is None:
            # Error handling: Return a 500 Internal Server Error with a JSON response
            response = make_response(
                jsonify({
                    "status": "error",
                    "message": "Handler failed to process the description."
                }),
                500
            )
        else:
            # Successful handling: Return a JSON response with the result
            response = make_response(
                jsonify({
                    "status": "success",
                    "description": result[0],  # First part of the tuple
                    "image": result[1]        # Second part of the tuple
                }),
                200
            )

        # Set response encoding to UTF-8
        response.headers['Content-Type'] = 'application/json; charset=utf-8'
        return response
    else:
        # Bad Request: Missing 'description' parameter
        return make_response(
            jsonify({
                "status": "error",
                "message": "Description parameter is missing."
            }),
            400
        )


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
