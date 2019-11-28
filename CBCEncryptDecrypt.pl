use Crypt::CBC;
use MIME::Base64 qw( encode_base64 decode_base64);

# Simple Encrypt Decrypt Process (Symmetric) - Use it for Distributed Block Storage to ensure File Itegriy Accross Distributed FS

  #### First B64 ENCODE FILE ############
    
  open INFILE, "Exer Eagle II Data Flow v4.ppt";
  binmode INFILE;
  open OUTFILE, ">B64Encoded_TECHNL01";
  
  my $buf;
  while ( read( INFILE, $buf, 60 * 57 ) ) {
      print OUTFILE encode_base64( $buf );
  }
  
  close OUTFILE;
  close INFILE;

  #### Now ENCRYPT FIle ############
 
  $key    = Crypt::CBC->random_bytes(8);  # assuming a 8-byte block cipher
  $iv     = Crypt::CBC->random_bytes(8);
  
  print "KEY: $key, IV: $iv \n";
  
  $cipher = Crypt::CBC->new(-literal_key => 1,
                            -key         => $key,
                            -iv          => $iv,
                            -header      => 'none'
                            );

  open(F,"B64Encoded_TECHNL01");
  open(O, ">Encrytped_B64Encoded_TECHNL01");
  
  $cipher->start('encrypting');
  while (read(F,$buffer,8)) {
      print O $cipher->crypt($buffer);
  }
  print O $cipher->finish;
  
  close F;
  close O;

  ######## Now DECRYPT FILE ###################
  
$cipher = Crypt::CBC->new(-literal_key => 1,
                            -key         => $key,
                            -iv          => $iv,
                            -header      => 'none');

  open(F,"Encrytped_B64Encoded_TECHNL01");
  open(O, ">Decrypted_TECHNL01");
  
  $cipher->start('decrypting');
  while (read(F,$buffer,8)) {
      print O $cipher->crypt($buffer);
  }
  print O $cipher->finish;
  
  close F;
  close O;
  
  ######## Now B64 Decode File ##################
  
  
  
open INFILE, "Decrypted_TECHNL01";
open OUTFILE, ">Decrypted__Decoded_Exer Eagle II Data Flow v4.ppt";

binmode OUTFILE;

my $buf;
while ( $buf = <INFILE> ) {
    print OUTFILE decode_base64( $buf );
}

close OUTFILE;
close INFILE;
  
  
  
