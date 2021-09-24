package com.josur.awsimageupload.config;

import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AmazonConfig {

//  Told spring boot to Make this class available to inject..
    @Bean
    public AmazonS3 s3() {
        AWSCredentials awsCredentials = new BasicAWSCredentials(
                "AKIA2MHUA6FX6PAD3WZK",
                "cWkUdwAD4L39uyDyluyJj5h//TrgB6Lqb+0w8OFT"
        );

        AmazonS3 amazonS3 = AmazonS3Client.builder()
                .withRegion("ap-southeast-1")
                .withCredentials(new AWSStaticCredentialsProvider(awsCredentials))
                .build();

        return amazonS3;
    }

}
