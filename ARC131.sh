# Task 1. Create an API key
# 1. For this task, you need to create an API key to use in this and other tasks when sending a request to the Speech-to-Text API.
# 2. Save the API key to use in other tasks.


# Task 2. Transcribe speech to English text
# Note: This lab uses a pre-recorded file that's available on Cloud Storage: gs://spls/arc131/question_en.wav. You can listen to this file.
# 1. For this task, connect to the instance lab-vm provisioned for you via SSH.
export API_KEY=
# 2. Create a file named speech_request_en.json as your API request to transcribe the audio file available at the gs://spls/arc131/question_en.wav location to English.
cat > "speech_request_en.json" <<EOF
{
  "config": {
    "encoding": "LINEAR16",
    "languageCode": "en-US",
    "audioChannelCount": 2
  },
  "audio": {
    "uri": "gs://spls/arc131/question_en.wav"
  }
}
EOF
# 3. Call speech_request_en.json and store the result in a file named speech_response_en.json.
curl -s -X POST -H "Content-Type: application/json" --data-binary @"speech_request_en.json" \
"https://speech.googleapis.com/v1/speech:recognize?key=${API_KEY}" > "speech_response_en.json"


# Task 3. Transcribe speech to Spanish text
# Note: This lab uses a pre-recorded file that's available on Cloud Storage: gs://spls/arc131/multi_es.flac. You can listen to this file.
# 1. For this task, connect to the instance lab-vm provisioned for you via SSH.
# 2. Create a file named request_sp.json as your API request to transcribe the audio file available at the gs://spls/arc131/multi_es.flac location to Spanish.
cat > "request_sp.json" <<EOF
{
  "config": {
    "encoding": "FLAC",
    "languageCode": "es-ES"
  },
  "audio": {
    "uri": "gs://spls/arc131/multi_es.flac"
  }
}
EOF
# 3. Call request_sp.json and store the result in the file named response_sp.json.
curl -s -X POST -H "Content-Type: application/json" --data-binary @"request_sp.json" \
"https://speech.googleapis.com/v1/speech:recognize?key=${API_KEY}" > "response_sp.json"