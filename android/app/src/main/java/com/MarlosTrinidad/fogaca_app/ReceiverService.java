package com.MarlosTrinidad.fogaca_app;


import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.res.AssetFileDescriptor;
import android.graphics.Color;
import android.graphics.PixelFormat;
import android.media.MediaPlayer;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Build;
import android.os.IBinder;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.core.app.NotificationCompat;

import com.MarlosTrinidad.fogaca_app.model.MotoboyAccount;
import com.google.android.gms.tasks.Continuation;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.FirebaseApp;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.EventListener;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.FirebaseFirestoreException;
import com.google.firebase.firestore.ListenerRegistration;
import com.google.firebase.functions.FirebaseFunctions;
import com.google.firebase.functions.HttpsCallableResult;
import com.google.gson.JsonObject;

import org.json.JSONObject;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.HttpURLConnection;
import java.net.InetSocketAddress;
import java.net.SocketException;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

import static com.github.florent37.assets_audio_player.notification.NotificationService.CHANNEL_ID;
import static io.flutter.plugins.firebase.auth.Constants.TAG;
import static io.flutter.plugins.firebase.auth.Constants.URL;

public class ReceiverService extends Service implements MediaPlayer.OnPreparedListener, MediaPlayer.OnCompletionListener {
    DatagramSocket server;
    Handler hand;

    byte[] receiveData = new byte[4024];

    WindowManager wm;


    WindowManager.LayoutParams lp;
    MediaPlayer mp;

    FirebaseUser user;
    MotoboyAccount account;

    private final FirebaseFirestore db=FirebaseFirestore.getInstance();

    FirebaseFunctions mFunctions;
    public ReceiverService() {

    }

    @Override
    public IBinder onBind(Intent intent) {
        // TODO: Return the communication channel to the service.
        throw new UnsupportedOperationException("Not yet implemented");
    }

    @Override
    public void onCreate() {
        super.onCreate();

        FirebaseApp.initializeApp(getBaseContext());
        mFunctions = FirebaseFunctions.getInstance();

        if(FirebaseAuth.getInstance().getCurrentUser() != null){
            user = FirebaseAuth.getInstance().getCurrentUser();
            db.collection("user_motoboy").document(user.getUid()).get().addOnCompleteListener(new OnCompleteListener<DocumentSnapshot>() {
                @Override
                public void onComplete(@NonNull Task<DocumentSnapshot> task) {
                    if(task.isSuccessful()){
                        account = (MotoboyAccount) task.getResult().toObject(MotoboyAccount.class);
                    }
                }
            });
        }
        hand = new Handler();

        mp = new MediaPlayer();

        wm = (WindowManager)getBaseContext().getSystemService(WINDOW_SERVICE) ;

        lp = new WindowManager.LayoutParams(WindowManager.LayoutParams.MATCH_PARENT, WindowManager.LayoutParams.WRAP_CONTENT);
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            lp.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY;
        }else {
            lp.type = WindowManager.LayoutParams.TYPE_SYSTEM_ALERT;
        }
        lp.format = PixelFormat.TRANSPARENT;
        lp.flags = WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN;


        lp.gravity = Gravity.CENTER;


        new Thread(){
            @Override
            public void run() {
                super.run();
                try {

                    if (server == null) {
                        server = new DatagramSocket(null);
                        server.setReuseAddress(true);
                        server.setBroadcast(true);
                        server.bind(new InetSocketAddress(3306));
                    }
                    //server = new DatagramSocket(3306);
                    while (true){

                        DatagramPacket packet = new DatagramPacket(receiveData, receiveData.length);
                        Log.i("SERVICE","AGUARDANDO");
                        try {
                            server.receive(packet);
                            String data = new String(packet.getData(), "UTF-8");
                            JSONObject json = new JSONObject(data );


                            createView(json);


                        } catch (Exception e) {
                            e.printStackTrace();
                        }

                    }

                } catch (SocketException e) {
                    e.printStackTrace();

                }
            }
        }.start();

    }

    public void createView(JSONObject json){
        try {
            String id_doc = (json.getString("id_doc"));
            TextView nome_lojista, end_lojista, quant_itens;
            LinearLayout lm = (LinearLayout) LayoutInflater.from(getBaseContext()).inflate(R.layout.activity_main_alert, null, false);
            nome_lojista = lm.findViewById(R.id.nome_loja);
            end_lojista = lm.findViewById(R.id.endereco_loja);
            quant_itens = lm.findViewById(R.id.quantitens_loja);

            nome_lojista.setText(json.getString("nome_ponto"));
            end_lojista.setText(json.getString("end_ponto"));
            quant_itens.setText(json.getString("quant_itens"));
            lm.findViewById(R.id.button_aceitar).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    aceitarCorrida(lm, id_doc);
                }
            });
            lm.findViewById(R.id.button_negar).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    fecharDialogo(lm);
                }
            });
            hand.post(() -> {

                wm.addView(lm, lp);
                listen(id_doc,lm);
                playSong();

            });
        }catch (Exception e){

        }

    }

    public void playSong(){
        try{

            // mp.reset();

            AssetFileDescriptor song = getResources().getAssets().openFd("somsino.mp3");
            mp.setDataSource(song.getFileDescriptor(), song.getStartOffset(), song.getLength());
            mp.setLooping(true);
            mp.setOnPreparedListener(this);
            mp.setOnCompletionListener(this);
            mp.prepareAsync();

            // mp.prepare();
            //  mp.start();

        }catch (Exception e){

            System.out.println("ErrorSong " + e.getMessage());
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    private void startMyOwnForeground(){
        String NOTIFICATION_CHANNEL_ID = "com.MarlosTrinidad.fogaca_app";
        String channelName = "Motoboy Online";
        NotificationChannel chan = new NotificationChannel(NOTIFICATION_CHANNEL_ID, channelName, NotificationManager.IMPORTANCE_NONE);
        chan.setLightColor(Color.BLUE);
        chan.setLockscreenVisibility(Notification.VISIBILITY_PRIVATE);
        NotificationManager manager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        assert manager != null;
        manager.createNotificationChannel(chan);

        if (android.os.Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID);
            Notification notification = notificationBuilder.setOngoing(true)
                    .setSmallIcon(R.drawable.icon_semfundo)
                    .setColor(getResources().getColor(R.color.pretoclaro))
                    .setContentTitle("Voçê está online")
                    .setPriority(NotificationManager.IMPORTANCE_MIN)
                    .setCategory(Notification.CATEGORY_SERVICE)
                    .build();
            startForeground(2, notification);
        } else {
            NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID);
            Notification notification = notificationBuilder.setOngoing(true)
                    .setSmallIcon(R.drawable.icon_semfundo)
                    .setContentTitle("Voçê está online")
                    .setPriority(NotificationManager.IMPORTANCE_MIN)
                    .setCategory(Notification.CATEGORY_SERVICE)
                    .build();
            startForeground(2, notification);

        }

    }
    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Log.i("onStartCommand",intent.getAction()+" "+flags+" "+startId);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
            startMyOwnForeground();
        else
            startForeground(1, new Notification());



        return START_STICKY;

    }

    @Override
    public void onDestroy() {
        stopPlaying();
        super.onDestroy();


    }
    public void listen(String id_doc, View view){
        try{
            final DocumentReference doc = db.collection("Pedidos").document(id_doc);
            doc.addSnapshotListener((snapshot, e) -> {

                // Toast.makeText(getBaseContext(), "Escutando Pedido", Toast.LENGTH_SHORT).show();
                if (e != null) {
                    Log.w(TAG, "Listen failed.", e);
                    return;
                }
                try{
                    if (snapshot != null && snapshot.exists() && snapshot.get("situacao") != null) {
                        Log.i("CORRIDA", snapshot.get("situacao").toString());
                        if(snapshot.get("situacao").toString().equals("Corrida Aceita")){

                            fecharDialogo(view);



                        }else if(snapshot.get("situacao").toString().equals("Cancelado") || !snapshot.get("temp_id").toString().equals(user.getUid())){
                            fecharDialogo(view);
                            return;
                        }
                    }
                }catch (Exception erro){
                    System.out.println("Error " + erro.getMessage());
                }
            });
        }catch(Exception e){
            System.out.println("Error " + e.getMessage());
        }
    }

    public void fecharDialogo(View lm){
        try{
            wm.removeView(lm);
            mp.stop();
            mp.reset();
        }catch(Exception e){
            System.out.println("Error " + e.getMessage());
        }

    }

    public void aceitarCorrida(View lm, String doc){
        //Verificando se tem net
        ConnectivityManager cm = (ConnectivityManager)ReceiverService.this.getBaseContext().getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo activeNetwork = cm.getActiveNetworkInfo();
        boolean isConnected = activeNetwork != null && activeNetwork.isConnectedOrConnecting();

        //caso tenha ele deixa passar
        if(isConnected){

            Map map = new HashMap<>();
            map.put("motoboy",account.getId());
            map.put("pedido", doc);


            mFunctions.getHttpsCallable("aceitarCorrida").call(map).continueWith(new Continuation<HttpsCallableResult, Object>() {
                @Override
                public Object then(@NonNull Task<HttpsCallableResult> task) throws Exception {
                    Log.e("ERROR LOG", task.getResult().getData().toString());
                    if(task.isSuccessful()){
                        fecharDialogo(lm);
                        Toast.makeText(ReceiverService.this, "Corrida Aceita", Toast.LENGTH_SHORT).show();
                    }else{

                        Toast.makeText(ReceiverService.this, "Não foi possível aceitar esta corrida", Toast.LENGTH_SHORT).show();
                    }
                    return task.getResult().getData().toString();
                }
            });
            /*
            new Thread(){
                @Override
                public void run() {
                    try {
                        Looper.prepare();
                        URL url = new URL("https://us-central1-fogaca-app.cloudfunctions.net/aceitarCorrida");
                        HttpURLConnection http = (HttpURLConnection) url.openConnection();
                        http.setRequestMethod("POST");
                        http.setDoOutput(true);
                        http.getOutputStream().write(map.toString().getBytes());
                        http.getOutputStream().flush();
                        if(http.getResponseCode() == 200){
                            fecharDialogo(lm);
                            Toast.makeText(ReceiverService.this, "Corrida Aceita", Toast.LENGTH_SHORT).show();
                        }else{
                            Toast.makeText(ReceiverService.this, "Não foi possível aceitar a corrida", Toast.LENGTH_SHORT).show();
                        }
                    }catch (Exception e){
                        Log.e("ERROR FIREBASE", e.toString());
                    }
                }
            }.start();

*/
            /*
        Map<String, Object> map = new HashMap<>();
        map.put("situacao","Corrida Aceita");
        map.put("boy_telefone", account.getTelefone());
        map.put("boy_foto",account.getIcon_foto());
        map.put("boy_id",account.getId());

        map.put("boy_nome",account.getNome());
        map.put("boy_moto_modelo",account.getModelo());
        map.put("boy_moto_placa",account.getPlaca());
        map.put("boy_moto_cor",account.getCor());
        db.collection("Pedidos").document(doc).update(map).addOnCompleteListener(new OnCompleteListener<Void>() {
            @Override
            public void onComplete(@NonNull Task<Void> task) {
               if(task.isSuccessful()){
                   Toast.makeText(ReceiverService.this.getBaseContext(), "Pedido Aceito", Toast.LENGTH_LONG).show();
                   fecharDialogo(lm);
               }else Toast.makeText(ReceiverService.this.getBaseContext(), "Não foi possível aceitar pedido", Toast.LENGTH_SHORT).show();
            }
        });

             */
        }else{
            Toast.makeText(ReceiverService.this.getBaseContext(), "Sem Conexão com a internet.", Toast.LENGTH_LONG).show();

        }
    }

    @Override
    public void onPrepared(MediaPlayer mp) {
        mp.start();
    }

    @Override
    public void onCompletion(MediaPlayer mp) {
        mp.release();
    }

    private void stopPlaying() {
        if (mp != null) {
            mp.stop();
            mp.release();
            mp = null;
        }
    }
}