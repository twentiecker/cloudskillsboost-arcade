# Task 1. Create an API key
# 1. For this task, you need to create an API key to use in this and other tasks when sending a request to the Speech-to-Text API.
# 2. Save the API key to use in other tasks.


# Task 2. Create synthetic speech from text using the Text-to-Speech API
# 1. For this task, connect to the VM instance lab-vm provisioned for you via SSH.
# 2. Activate the virtual environment using the source venv/bin/activate command.
source venv/bin/activate
# 3. Using a text editor (such as nano or vim), create a file named synthesize-text.json and paste the following into the file:
nano synthesize-text.json
# 4. Call the Text-to-Speech API to synthesize the text of the synthesize-text.json file, and store the result in a file named synthesize-text.txt.
curl -H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
  -H "Content-Type: application/json; charset=utf-8" \
  -d @synthesize-text.json "https://texttospeech.googleapis.com/v1/text:synthesize" \
  > synthesize-text.txt
# 5. Using a text editor (such as nano or vim), create a file named tts_decode.py and paste the following code into that file:
nano tts_decode.py
# 6. Now, to create an audio file using the response you received from the Text-to-Speech API, run the following command from Cloud Shell:
python tts_decode.py --input "synthesize-text.txt" --output "synthesize-text-audio.mp3"
# 7. Finally, download the audio file via the DOWNLOAD FILE option of the VM instance's SSH session in order to listen to it.


# Task 3. Perform speech to text transcription with the Cloud Speech API
# Note: This lab uses a pre-recorded file that's available on Cloud Storage: gs://cloud-samples-data/speech/corbeau_renard.flac. You can listen to this file.
# 1. For this task, connect to the VM instance lab-vm provisioned for you via SSH.
export API_KEY=
# 2. Using a text editor (such as nano or vim), create a file named speech_request_fr.json as your API request to transcribe the audio file available at the gs://cloud-samples-data/speech/corbeau_renard.flac location to French.
cat > "speech_request_fr.json" <<EOF
{
  "config": {
    "encoding": "FLAC",
    "sampleRateHertz": 44100,
    "languageCode": "fr-FR"
  },
  "audio": {
    "uri": "gs://cloud-samples-data/speech/corbeau_renard.flac"
  }
}
EOF
# 3. Call speech_request_fr.json and store the result in a file named speech_response_fr.json.
curl -s -X POST -H "Content-Type: application/json" \
    --data-binary @"speech_request_fr.json" \
    "https://speech.googleapis.com/v1/speech:recognize?key=${API_KEY}" \
    -o "speech_response_fr.json"


# Task 4. Translate text with the Cloud Translation API
# 1. For this task, connect to the VM instance lab-vm provisioned for you via SSH.
# 2. Translate the これは日本語です。 sentence to the English language by calling the Cloud Translation API and store the result in the translated_response.txt file.
curl -s -X POST \
-H "Authorization: Bearer $(gcloud auth application-default print-access-token)" \
-H "Content-Type: application/json; charset=utf-8" \
-d "{\"q\": \"これは日本語です。\"}" \
"https://translation.googleapis.com/language/translate/v2?key=${API_KEY}&source=ja&target=en" > translated_response.txt


# Task 5. Detect a language with the Cloud Translation API
# 1. For this task, connect to the VM instance lab-vm provisioned for you via SSH.
# 2. Detect the language of the Este%é%japonês. sentence by calling the Cloud Translation API and store the result in the detected_response.txt file.
curl -s -X POST \
  -H "Authorization: Bearer $(gcloud auth application-default print-access-token)" \
  -H "Content-Type: application/json; charset=utf-8" \
  -d "{\"q\": [\"Este%é%japonês\"]}" \
  "https://translation.googleapis.com/language/translate/v2/detect?key=${API_KEY}" \
  -o "detected_response.txt"