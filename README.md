
# 利用Shader来实现Sprite的Outline效果

* 只需在SpriteRenderer上绑定SpriteOutline组件，即可实现Outline效果

  * OutlineSize控制厚度
  
  * Color控制颜色

![image](https://github.com/wlgys8/Sprites-Outline/blob/master/readme_assets/inspector.png)

* Demo效果图:

![image](https://github.com/wlgys8/Sprites-Outline/blob/master/readme_assets/preview.png)


## 使用限制

* Sprite MeshType 必须为FullRect
* Sprite的图片四周留一定的空白。否则生成的SpriteRenderMesh将没有足够的空间用于渲染Outline
* Outline的厚度无法超过Sprite最细的部分
