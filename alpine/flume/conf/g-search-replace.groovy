println head
println body
body=body.replace('a','aaa')
head["newhead"]='abcd'

def resultMap = [:]

resultMap["head"]=head
resultMap["body"]=body

return resultMap