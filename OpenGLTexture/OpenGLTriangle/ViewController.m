//
//  ViewController.m
//  OpenGLTriangle
//
//  Created by Gzedu on 2017/6/27.
//  Copyright © 2017年 Gzedu. All rights reserved.
//

#import "ViewController.h"
typedef struct {
    //坐标向量
    GLKVector3 positionCoords;
    
    GLKVector2 textureCoords;
}scene;

//顶点数据 用浮点类型
static const scene point[] = {
    0.5, -0.5, 0.0f,    1.0f, 0.0f, //右下
    0.5, 0.5, -0.0f,    1.0f, 1.0f, //右上
    -0.5, 0.5, 0.0f,    0.0f, 1.0f, //左上
    
};

@interface ViewController ()
//顶点数据缓存的标识符
@property (nonatomic,assign)GLuint bufferID;
//着色器
@property (nonatomic,strong) GLKBaseEffect *baseEffect;
//上下文
@property (nonatomic,strong)EAGLContext *context;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *v = (GLKView *)self.view;
    //初始化上下文
    self.context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    v.context = self.context;
    //设置当前的上下文
    [EAGLContext setCurrentContext:self.context];
    
    
    //创建缓存
    glGenBuffers(1, &_bufferID);//生成标识符
    glBindBuffer(GL_ARRAY_BUFFER, _bufferID);//绑定
    glBufferData(GL_ARRAY_BUFFER, sizeof(point), point, GL_STATIC_DRAW);//复制顶点数据到缓存中
    glEnableVertexAttribArray(GLKVertexAttribPosition);//允许,顶点缓存
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(scene), NULL);//告诉OpenGL顶点数据在哪里
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0); //纹理告诉OpenGL纹理的数据在哪里
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(scene) , NULL);
    
    //纹理贴图
    CGImageRef imageRef = [[UIImage imageNamed:@"11"] CGImage];
    GLKTextureInfo *info = [GLKTextureLoader textureWithCGImage:imageRef options:nil error:NULL];
    
    //着色器
    self.baseEffect = [[GLKBaseEffect alloc]init];
    self.baseEffect.texture2d0.name = info.name;
    self.baseEffect.texture2d0.target = info.target;
    
    
}
//在代理中实现重绘
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    //背景颜色
    glClearColor(1.0, 0.0, 0.0, 1.0);
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    [self.baseEffect prepareToDraw];
    
    glDrawArrays(GL_TRIANGLES, 0, 3);//重绘
}



@end
