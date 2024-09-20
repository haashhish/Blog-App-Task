# Blog-App-Task
- Post "user/create": to be able to create new users, and a token is returned to authenticate later while using all other endpoints. It should get a JSON body with the following format: {"user": {"email": "", ..etc}}
- Get "user/login": to login with the email & password combination, a token is returned to access all other functionalities that need authentication. It should get a JSON body with the following format: {"user": {"email": "", "password": ""}}
- Post "post/new": to create a new post which belongs to the author(user). It should get a JSON body with the following format: {"post": {"title": "", "tags": ["",""],..etc}}
- Put "post/update": to let the author update the title and/or the body of his post, and it must be done by the author
- Put "post/tags": to update the tags of specific posts, and it must be done by the author
- Delete "post": to delete a specific post, and it must be done by the author
- Post "comment/create": any author is capable of adding any comment on an existing post. It should get a JSON body with the following format: {"comment": {"body":""}
- Delete "comment": the author of any comment can delete his/her own comment
- Put "comment": to update the text of a specific comment, and it must be done by the author. It should get a JSON body with the following format: {"comment": {"post_id": "", "body": ""}
