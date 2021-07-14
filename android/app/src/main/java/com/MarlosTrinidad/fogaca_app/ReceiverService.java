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
import android.os.Build;
import android.os.IBinder;
import android.os.Handler;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.core.app.NotificationCompat;

import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.EventListener;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.FirebaseFirestoreException;

import org.json.JSONObject;

import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.SocketException;
import java.nio.charset.StandardCharsets;

import static com.github.florent37.assets_audio_player.notification.NotificationService.CHANNEL_ID;
import static io.flutter.plugins.firebase.auth.Constants.TAG;

public class ReceiverService extends Service {
    DatagramSocket server;
    Handler hand;

    byte[] receiveData = new byte[4024];

    WindowManager wm;
    TextView nome_lojista, end_lojista,quant_itens;
    String id_doc;
    LinearLayout lm;
    WindowManager.LayoutParams lp;
    MediaPlayer mp;
    private final FirebaseFirestore db=FirebaseFirestore.getInstance();
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
        hand = new Handler();

        mp = new MediaPlayer();

        wm = (WindowManager)getBaseContext().getSystemService(WINDOW_SERVICE) ;
        lm = (LinearLayout) LayoutInflater.from(getBaseContext()).inflate(R.layout.activity_main_alert, null, false);
        lp = new WindowManager.LayoutParams(WindowManager.LayoutParams.MATCH_PARENT, WindowManager.LayoutParams.WRAP_CONTENT);
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            lp.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY;
        }else {
            lp.type = WindowManager.LayoutParams.TYPE_SYSTEM_ALERT;
        }
        lp.format = PixelFormat.TRANSPARENT;
        lp.flags = WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN;


        lp.gravity = Gravity.CENTER;

        nome_lojista = lm.findViewById(R.id.nome_loja);
        end_lojista = lm.findViewById(R.id.endereco_loja);
        quant_itens = lm.findViewById(R.id.quantitens_loja);

        lm.findViewById(R.id.button_aceitar).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                wm.removeView(lm);
                mp.release();
            }
        });

        new Thread(){
            @Override
            public void run() {
                super.run();
                try {
                    server = new DatagramSocket(3306);
                    while (true){

                        DatagramPacket packet = new DatagramPacket(receiveData, receiveData.length);
                        Log.i("SERVICE","AGUARDANDO");
                        try {
                            server.receive(packet);
                            String data = new String(packet.getData(), "utf8");
                            JSONObject json = new JSONObject(data );
                            Log.i("Erro::",json.getString("nome_ponto"));
                            nome_lojista.setText(json.getString("nome_ponto"));
                            end_lojista.setText(json.getString("end_ponto"));
                            quant_itens.setText(json.getString("quant_itens"));
                            id_doc=(json.getString("id_doc"));
                            hand.post(() -> {
                                wm.addView(lm, lp);
                                playSong();
                            });
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

    public void playSong(){
        try{
            mp.reset();
            AssetFileDescriptor song = getResources().getAssets().openFd("somsino.mp3");
            mp.setDataSource(song.getFileDescriptor(), song.getStartOffset(), song.getLength());
            mp.prepare();
            mp.start();
            mp.isLooping();
        }catch (Exception e){

            Log.i("Erro::",e.toString());
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

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
            startMyOwnForeground();
        else
            startForeground(1, new Notification());



        return START_STICKY;

    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        mp.release();

    }
    public void VerificarPedido(){
        final DocumentReference docRef = db.collection("Pedidos").document(id_doc);
        docRef.addSnapshotListener(new EventListener<DocumentSnapshot>() {
            @Override
            public void onEvent(@Nullable DocumentSnapshot snapshot,
                                @Nullable FirebaseFirestoreException e) {
                if (e != null) {
                    Log.w(TAG, "Listen failed.", e);
                    return;
                }

                if (snapshot != null && snapshot.exists()) {

                    Log.d(TAG, "Current data: " + snapshot.getData());
                } else {
                    Log.d(TAG, "Current data: null");
                }
            }
        });

    }
}