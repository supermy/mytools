import  com.supermy.flume.interceptor.*
import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;

println head
println body
body=body.replace('a','aaa')
head["newhead"]='abcd'



String text = "Body 的数据 , I Love BONC"

//
def key = new SecretKeySpec("123456789987654321".bytes, "AES")
def c = Cipher.getInstance("AES")

//加密
c.init(Cipher.ENCRYPT_MODE, key)
e_text = new String(Hex.encodeHex(c.doFinal(text.getBytes("UTF-8"))))

//解密
c.init(Cipher.DECRYPT_MODE, key)
text1 = new String(c.doFinal(Hex.decodeHex(e_text.toCharArray())))

println text
println e_text
println text1


def resultMap = [:]

//加密数据，用于互联网数据传输


resultMap["head"]=head
resultMap["body"]=body

return resultMap