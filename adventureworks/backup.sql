backup database adventureworks into  'nodelocal://1/Adventureworks1.backup' 
// gcloud auth login
// gcloud config set project ghreqs
// see https://www.justuno.com/blog/protect-your-data-using-cockroach-backups/
// Also some screenshots taken June 11 2021

SET CLUSTER SETTING cloudstorage.gs.default.key = '{
  "type": "service_account",
  "project_id": "ghreqs",
  "private_key_id": "048d8c08c90032758aba99d77676a84c1ceef9fa",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCivFBuKnXingKm\nG/C8gMmx/wG1V+8VmMPVSYQrKcUsJAVjL883zvARpo30ggVhT4641fvLQzBZRcqR\n2Hr6QAFl2Lpp2fbF1tpjnwz/X37PwSl4xc2kkozkcITT393dKURodMH9bUldSC3g\nrETUk5YP+ps1C+M4frmR3HpIRjsQJYr+9k+2yWBSg+Fj0g2PvkAQJzSu+wcJvk+h\nMKE0w2uIjoIIjzbfwEMJPyxEea8ZgPah3SKkE+oHyjmu8SVfYxk8FDLoqKdfAkzI\nsdRADtQ+edsa/9kKfDDxgcRtqtW8SyOZ9DdJNSkrxWftkjkJWRM68SsJTnTg/cgN\nL2ncmRSZAgMBAAECggEAGuGsEJKjgAB1dA57/QtyJdy3ocbJh+IBAWfANSgUebbm\ni+yfGHsuxV+jpd7feCRd8VLpobky0KBadq6Rm+p8QKBlJKycWrBjyV6B1WJnLnbc\nPKbCEjwiGW8rxdr+SXTyZ6XX0J7fplDQwUL7qLjLak7NmhzhVxj52uoWaf9t7Lvf\nPDSDsZWUpLGdB7dvZvke97hMsSGdxPZwKoz59vppu1fMR1GMYZFMki53ZYeiPmmf\n4iF893vB3LwKxtFpSq0GJ0u9Dnk1/4BCaOctFDlHDDO43ftwJfpQ6928oRsE2F6I\npQm5gvAtTO8RlyP+/+apzIHev+TSxc9dNINhLzR5XQKBgQDdMkPGek85hoYvWe//\nhI3HvM4yy4BN1jxTtMJRUaMv9iGKMPRqE1dkPX5oy1yxtNTshlxl4OWo4vi72YpM\njZDi1H7dZ2tQ4y1FF22PVLm5SbipWZD1j1MSoOOEWosawmyewCGUPx+KoSCohAPK\nwAQ9jcUocMWhFH6Y2qV1hGSkFQKBgQC8V0PKykohWfmrjSr5d3/bAPK8G2Ldmrkx\nDa58D71OGXmNMikIrr1k9Z6jfXy+QPk9saYP9dV35Lr9qBbK0X6TcwNyAbWMtr5N\nGXLm8/2iIu/6nHKLgNMywPN2qZCQkrjy7W31DOTe4J3RhvKspZlxUbAxTgyy19ag\nOoYVXbR7dQKBgCAG1BtbwDbTDIC0o/Q6LBEcfDqMjoI2n7t685u0l00tdQO+PNVT\nAZdI9BGWSFCOnzmz5pL1sir22g7Q255j7PN60veZrscibX6QetOC7/UtAGi8yClV\n3DBZTTfvqC5ysil2JiaB0T5QQBtGKgpkLPkAmuhVE7hT8FSPa9+NEMlVAoGAG3En\nmouhA30FqN5XzaOAyJs5wvjGjf12UFRrAP6WGaQSluUhH3e+dtBm/fFR1LLI3hld\nVeP+54o3SLBOKd0ecUOH0/u1xTv3PGqh2E7ivNYUW1KiSftKSpHcp4SLYNVQB21a\n4SKw0lyuAhKEl21Fj0JUxspVhVV3mz8LvF875eUCgYAiKTatqLnCfjcENy1V+wma\nKtk8YqMhA/tS0Dcvdb7qC93b9xzfjiYPJJz0wSyY5Ps4l+KVZREDf1jIaFqeobky\nJK7bnDf+O1eR1qeufGtZIVXQ5nmCczLD7ATnloa6B+/EOIMmM3hljj7udawwrrGI\n6/9Yykfy5cPMvVixA9etdg==\n-----END PRIVATE KEY-----\n",
  "client_email": "592053976296-compute@developer.gserviceaccount.com",
  "client_id": "112395942388993483786",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/592053976296-compute%40developer.gserviceaccount.com"
}';
backup database adventureworks into 'gs://ghcrdb/Adventureworks1.backup' ;

RESTORE DATABASE adventureworks FROM 'gs://ghcrdb/Adventureworks1.backup';