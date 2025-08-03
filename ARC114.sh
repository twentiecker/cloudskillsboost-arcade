# Task 1. Create an API key
# 1. For this task, you need to create an API key to use in this and other tasks when sending a request to the Natural Language API.


# Task 2. Make an entity analysis request and call the Natural Language API
# 1. For this task, connect to the instance lab-vm provisioned for you via SSH.
# 2. Next, create a JSON file named nl_request.json which you will pass to the Natural Language API for analysis. You can add the following code to your JSON file to analyze text about the city of Boston or, alternatively, add text of your own choosing to the content object to perform entity analysis on that instead.
nano nl_request.json 
# 3. You can now pass your request body, along with the API key environment variable you saved earlier, to the Natural Language API using the curl command or analyze the text using gcloud ML commands.
# 4. Save the response in a file called nl_response.json
export API_KEY=
curl "https://language.googleapis.com/v1/documents:analyzeEntities?key=${API_KEY}" \
  -s -X POST -H "Content-Type: application/json" --data-binary @nl_request.json > nl_response.json


# Task 3. Create a speech analysis request and call the Speech API
# Note: For this task, you will use a pre-recorded file that's available on Cloud Storage: gs://cloud-samples-tests/speech/brooklyn.flac. Listen to the audio file before sending it to the Speech API.
# 1. Create another JSON file, named speech_request.json for this task, and add the content using the URI value of the sample audio file.
nano speech_request.json
# 2. You can now pass your request body, along with the API key environment variable that you saved earlier, to the Natural Language API using the curl command or analyze the speech using gcloud ML commands.
# 3. Save the response in a file named speech_response.json.
curl -s -X POST -H "Content-Type: application/json" --data-binary @speech_request.json \
"https://speech.googleapis.com/v1/speech:recognize?key=${API_KEY}" > speech_response.json


# Task 4. Analyze sentiment with the Natural Language API
# 1. You need to edit the method def analyze(movie_review_filename): in the file sentiment_analysis.py and complete the method using Python code that performs the following actions:
cat > sentiment_analysis.py <<EOF

import argparse

from google.cloud import language_v1

def print_result(annotations):
    score = annotations.document_sentiment.score
    magnitude = annotations.document_sentiment.magnitude

    for index, sentence in enumerate(annotations.sentences):
        sentence_sentiment = sentence.sentiment.score
        print(
            f"Sentence {index} has a sentiment score of {sentence_sentiment}"
        )

    print(
        f"Overall Sentiment: score of {score} with magnitude of {magnitude}"
    )
    return 0


def analyze(movie_review_filename):
    """Run a sentiment analysis request on text within a passed filename."""
    client = language_v1.LanguageServiceClient()

    with open(movie_review_filename) as review_file:
        # Instantiates a plain text document.
        content = review_file.read()

    document = language_v1.Document(
        content=content, type_=language_v1.Document.Type.PLAIN_TEXT
    )
    annotations = client.analyze_sentiment(request={"document": document})

    # Print the results
    print_result(annotations)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser.add_argument(
        "movie_review_filename",
        help="The filename of the movie review you'd like to analyze.",
    )
    args = parser.parse_args()

    analyze(args.movie_review_filename)

EOF
# 2. Download the fictitious movie review samples from Google Cloud Storage: gs://cloud-samples-tests/natural-language/sentiment-samples.tgz .
gsutil cp gs://cloud-samples-tests/natural-language/sentiment-samples.tgz .
# 3. Unzip the sample files and run the sentiment analysis on one of the files, bladerunner-pos.txt, using the relevant Python command.
gunzip sentiment-samples.tgz
tar -xvf sentiment-samples.tar
python3 sentiment_analysis.py reviews/bladerunner-pos.txt

