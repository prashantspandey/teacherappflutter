package com.bodhiaiteacherflutter.in;
//package com.example.bodhiai_teacher_flutter;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Handler;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

import com.amazonaws.auth.CognitoCachingCredentialsProvider;
import com.amazonaws.mobileconnectors.s3.transferutility.TransferListener;
import com.amazonaws.mobileconnectors.s3.transferutility.TransferObserver;
import com.amazonaws.mobileconnectors.s3.transferutility.TransferState;
import com.amazonaws.mobileconnectors.s3.transferutility.TransferUtility;
import com.amazonaws.regions.Region;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;

import java.io.File;
import java.util.HashMap;
import java.util.List;


public class MainActivity extends FlutterActivity {
   private static final String CHANNEL = "s3integration";
  private static final String YOUTUBECHANNEL = "youtube";
  private EventChannel channel;
  TransferObserver transferObserver;
  AmazonS3 s3Client;



  String bucket = "instituteimages";
  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {


    //GeneratedPluginRegistrant.registerWith(flutterEngine);
    s3credentialsProvider();
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),CHANNEL).setMethodCallHandler((call, result)->{
      if(call.method.equals("uploadFiles")){

        String filePath = call.argument("path");
        String fileName = call.argument("fileName");
        Log.i("in upload file android",filePath);
        File uploadFile = new File(filePath);

        TransferUtility transferUtility= new TransferUtility(s3Client,getApplicationContext());
        transferObserver = transferUtility.upload(
                bucket,          /* The bucket to upload to */
                fileName,/* The key for the uploaded object */
                uploadFile       /* The file where the data to upload exists */
        );

        transferObserverListener(transferObserver);
        TransferState finalState = transferObserver.getState();



        HashMap<String,String> statusJson= new HashMap<>();
        statusJson.put("status","Success");
        statusJson.put("url",String.format("https://instituteimages.s3.amazonaws.com/%s",fileName.replace(" ","")));
        result.success(statusJson);
      }



    });



    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),YOUTUBECHANNEL).setMethodCallHandler((call, result)->{
      if (call.method.equals("canStartStream")) {
        validateMobileLiveIntent(getApplicationContext());


      }


    });

    new EventChannel(flutterEngine.getDartExecutor(),"uploadEvents").setStreamHandler(
            new EventChannel.StreamHandler() {
              @Override
              public void onListen(Object arguments, EventChannel.EventSink events) {
               transferObserverListener(transferObserver);
                TransferState finalState = transferObserver.getState();
                Log.i("bytes events transfer",String.valueOf(transferObserver.getBytesTransferred()));
                  Handler progressHandler = new Handler();
                progressHandler.postDelayed(new Runnable() {
                  @Override
                  public void run() {
                    //Log.i("bytes runnable transfer",String.valueOf(transferObserver.getBytesTransferred()));
                    //Log.i("bytes runnable total",String.valueOf(transferObserver.getBytesTotal()));
                    long done = transferObserver.getBytesTransferred();
                    long total = transferObserver.getBytesTotal();
                    HashMap toTransfer = new HashMap();
                    float percentage;
                    try {
                        percentage =  ((float) done / total)*100;
                        
                    Log.i("percentage uploaded",String.valueOf(percentage));
                     // toTransfer.put("percentage",percentage);
                      //toTransfer.put("state",finalState);
                    }
                    catch (Exception e){
                        percentage = 0;
                    }
                    if (percentage == (float)100.0){
                      Log.i("percentage uploaded","transfer complete end of stream");
                      events.success(percentage);
                        events.endOfStream();
                    }
                    else{
                       // toTransfer.put("percentage",percentage);
                       // toTransfer.put("state",finalState);
                        events.success(percentage);
                    }

                    progressHandler.postDelayed(this,1000);
                  }
                },1000);

              }

              @Override
              public void onCancel(Object arguments) {

              }
            }
    );
  }




  public void s3credentialsProvider(){

    // Initialize the AWS Credential
    CognitoCachingCredentialsProvider cognitoCachingCredentialsProvider =
            new CognitoCachingCredentialsProvider(
                    getApplicationContext(),
                    "us-east-1:74e75d99-d674-4b71-aed6-5b2bc9176a5a", // Identity Pool ID
                    Regions.US_EAST_1 // Region
            );
    createAmazonS3Client(cognitoCachingCredentialsProvider);
  }

  /**
   *  Create a AmazonS3Client constructor and pass the credentialsProvider.
   * @param credentialsProvider
   */
  public void createAmazonS3Client(CognitoCachingCredentialsProvider
                                           credentialsProvider){

    // Create an S3 client
    s3Client = new AmazonS3Client(credentialsProvider,Region.getRegion(Regions.US_EAST_1));
    //s3Client = new AmazonS3Client(credentialsProvider);

    // Set the region of your S3 bucket
    s3Client.setRegion(Region.getRegion(Regions.US_EAST_1));
  }



  public void transferObserverListener(TransferObserver transferObserver) {

    transferObserver.setTransferListener(new TransferListener() {

      @Override
      public void onStateChanged(int id, TransferState state) {
      Log.i("state changed",state.toString());

      }

      @Override
      public void onProgressChanged(int id, long bytesCurrent, long bytesTotal) {


      }

      @Override
      public void onError(int id, Exception ex) {
        Log.e("error", "error");
      }

    });
  }
  private boolean canResolveMobileLiveIntent(Context context) {
    Intent intent = new Intent("com.google.android.youtube.intent.action.CREATE_LIVE_STREAM")
            .setPackage("com.google.android.youtube");
    PackageManager pm = context.getPackageManager();
    List resolveInfo =
            pm.queryIntentActivities(intent, PackageManager.MATCH_DEFAULT_ONLY);
    return resolveInfo != null && !resolveInfo.isEmpty();
  }


  private void validateMobileLiveIntent(Context context) {
    if (canResolveMobileLiveIntent(context)) {
      Intent mobileLiveIntent = createMobileLiveIntent(context, "Streaming via ...");
      startActivity(mobileLiveIntent);


    } else {
    }
  }

  private Intent createMobileLiveIntent(Context context, String description) {
    Intent intent = new Intent("com.google.android.youtube.intent.action.CREATE_LIVE_STREAM")
            .setPackage("com.google.android.youtube");
    Uri referrer = new Uri.Builder()
            .scheme("android-app")
            .appendPath(context.getPackageName())
            .build();

    intent.putExtra(Intent.EXTRA_REFERRER, referrer);
    if (!TextUtils.isEmpty(description)) {
      intent.putExtra(Intent.EXTRA_SUBJECT, description);
    }
    return intent;
  }
}
