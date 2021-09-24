package com.josur.awsimageupload.bucket;

public enum BucketName {

    PROFILE_IMAGE("josur-image-upload-123");

    private final String bucketName;

    BucketName(String bucketName) {
        this.bucketName = bucketName;
    }

    public String getBucketName() {
        return bucketName;
    }
}
