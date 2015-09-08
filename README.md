# YBImgPicker
//使用方法：
   
    YBImgPickerViewController * next = [[YBImgPickerViewController alloc]init];
    
    [next showInViewContrller:self choosenNum:0 delegate:self];
    
    //直接创建，调用显示方法

//回调：
   
- (void)YBImagePickerDidFinishWithImages:(NSArray *)imageArray {
          
        for (UIImage * image in imageArray) {
             
             .......
          
        }
    }
