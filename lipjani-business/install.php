<?php
declare(strict_types=1);
if(PHP_SAPI!=='cli'){http_response_code(404);exit('Not found');}
$force=in_array('--force',$argv,true);$config=__DIR__.'/config.php';if(!is_file($config)){fwrite(STDERR,"Missing config.php. Copy config.example.php and set MySQL details.\n");exit(1);}
$cfg=require $config;$pdo=new PDO('mysql:host='.$cfg['db_host'].';dbname='.$cfg['db_name'].';charset=utf8mb4',$cfg['db_user'],$cfg['db_pass'],[PDO::ATTR_ERRMODE=>PDO::ERRMODE_EXCEPTION]);
$email='lipjani@gmail.com';$q=$pdo->prepare('SELECT id FROM users WHERE email=?');$q->execute([$email]);$id=$q->fetchColumn();$hash=password_hash('123',PASSWORD_DEFAULT);
if($id){if(!$force){fwrite(STDOUT,"Administrator exists. Use --force only to reset the initial password.\n");exit(0);}$pdo->prepare("UPDATE users SET password_hash=?,role='admin',full_name='Lipjani Administrator' WHERE id=?")->execute([$hash,$id]);}
else{$pdo->prepare("INSERT INTO users(full_name,email,phone,password_hash,role) VALUES('Lipjani Administrator',?,'',?,'admin')")->execute([$email,$hash]);}
fwrite(STDOUT,"Administrator initialized: ".$email."\n");

