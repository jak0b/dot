function s3bucketDeleteAllVersion() {
  local bucket="$1"
  if [ -z "$bucket" ]; then
    echo "No bucket"
    return 1
  fi

  local all_objects=$(aws s3api list-object-versions \
        --bucket "$bucket" \
        --output=json \
        --query='{Objects: Versions[].{Key:Key,VersionId:VersionId}}')
  echo -n "$all_objects"
  # TODO:
  # fix string comparison in case the bucket is empty
  if [ "$all_objects" = '{\n    "Objects": null\n}' ]; then
    echo "Bucket has no versions"
    return 2
  fi

  aws s3api delete-objects \
    --bucket "$bucket" \
    --delete "$all_objects"
}
