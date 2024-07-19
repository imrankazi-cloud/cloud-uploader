#! /bin/bash

# Check if AWS cli is installed

if ![ -x "$(command -v aws)"]; then
   echo "Error: aws-cli is not installed" >&2
   exit 1
fi

if ['$#' lt 1]; then
    echo "Usage: clouduploader /path/to/clouduploader.sh [bucket_name] [target_path]"
    exit 1
fi

#Assign variables
FILE=$1
BUCKET=${2:my-defaul-bucket}
TARGET_PATH=${3:-} 

#Check if file exists
if [! -f "$FILE"]; then
    echo "File $FILE does not exist."
    exit 1
fi

#Copy file to s3 bucket
if [-z "$TARGET_PATH"]; then
    aws s3 cp "$FILE" "s3://$BUCKET/"
else
    aws s3 cp "$FILE" "s3://$BUCKET/$TARGET_PATH"
fi

$ Check file uploaded successfully

if ["$?" -eq 0]; then
    echo "File uploaded successfully."
else
    echo "File upload failed."
fi


