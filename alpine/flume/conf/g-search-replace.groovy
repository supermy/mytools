import com.supermy.flume.interceptor.*

import javax.crypto.Cipher
import javax.crypto.spec.SecretKeySpec
import javax.xml.bind.DatatypeConverter;

//import java.util.Base64;//jdk8
println head
println body
body = body.replace('a', 'aaa')
head["newhead"] = 'abcd'



String text = "Body 的数据 , I Love BONC"
// 编码  加密解密要用 base 进行编码与解码否则很容易异常信息
//String asB64 = Base64.getEncoder().encodeToString(text.getBytes("utf-8"));

String asB64 = DatatypeConverter.printBase64Binary(text.getBytes());
//System.out.println(encodeds1);

//秘钥只能是16位长度
def key = new SecretKeySpec("1234567887654321".bytes, "AES")
def c = Cipher.getInstance("AES")

//加密
c.init(Cipher.ENCRYPT_MODE, key)
e_text = new String(Hex.encodeHex(c.doFinal(asB64.getBytes("UTF-8"))))

//解密
c.init(Cipher.DECRYPT_MODE, key)
text1 = new String(c.doFinal(Hex.decodeHex(e_text.toCharArray())))

// 解码
//byte[] asBytes = Base64.getDecoder().decode(text1);

byte[] asBytes = DatatypeConverter.parseBase64Binary(text1);
//System.out.println(new String(decodeds1));


println text
println e_text
println new String(asBytes)


def resultMap = [:]

//加密数据，用于互联网数据传输


resultMap["head"] = head
resultMap["body"] = body

return resultMap