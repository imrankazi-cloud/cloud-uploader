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

#Copy file to s3 bucket and added progress bar
if [-z "$TARGET_PATH"]; then
   pv "$FILE" | aws s3 cp "$FILE" "s3://$BUCKET/"
else
   pv "$FILE" | aws s3 cp "$FILE" "s3://$BUCKET/$TARGET_PATH"
fi

# Check file uploaded successfully

if ["$?" -eq 0]; then
    echo "File uploaded successfully."
else
    echo "File upload failed."
fi

#Create shareable link

SHARE_URL=$(aws s3 presign"s3://$BUCKET/$(basename $FILE)")
echo "File uploaded successfully. Shareable link: $SHARE_URL"

