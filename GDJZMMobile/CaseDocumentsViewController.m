//
//  CaseDocumentsViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CaseDocumentsViewController.h"

#define DeleteDocAlertTag 100
#define ReDefaultDocAlertTag 200

typedef enum {
    PDFWithTable=0,
    PDFWithoutTable,
} PDFType;

@interface CaseDocumentsViewController (){
    //是否有新文书生成
    BOOL newFile;
}
@property (nonatomic,assign) NSInteger docIndex;
@property (nonatomic,assign) NSInteger docCount;
@property (nonatomic,retain) NSURL *pdfFileURL;
@property (nonatomic,retain) NSURL *pdfFormatFileURL;
//已生成文书查看模式下，保存文书路径及名称
@property (nonatomic,readonly) NSArray *docPDFArray;
@property (nonatomic,readonly) NSDictionary *TableMapping;
-(NSString *)docPathFromFileName;
-(void)keyboardWillShow:(NSNotification *)aNotification;
-(void)keyboardWillHide:(NSNotification *)aNotification;
@end

@implementation CaseDocumentsViewController
@synthesize editorView=_editorView;
@synthesize pdfView=_pdfView;
@synthesize pageControl = _pageControl;
@synthesize uiButtonPrintPreview = _uiButtonPrintPreview;
@synthesize uiButtonPrintFull = _uiButtonPrintFull;
@synthesize uiButtonPrintForm = _uiButtonPrintForm;
@synthesize fileName=_fileName;
@synthesize docPrinter=_docPrinter;
@synthesize caseID=_caseID;

@synthesize docReloadDelegate=_docReloadDelegate;
@synthesize docPrinterState=_docPrinterState;
@synthesize pdfFileURL=_pdfFileURL;
@synthesize pdfFormatFileURL=_pdfFormatFileURL;

@synthesize TableMapping=_TableMapping;
@synthesize docCount = _docCount;
@synthesize docIndex = _docIndex;
@synthesize docPDFArray = _docPDFArray;

@synthesize parameters = _parameters;

#pragma mark - setter & getter
- (NSDictionary *)TableMapping{
    if (_TableMapping==nil) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
        NSPropertyListFormat format;
        NSString *errorDesc = nil;
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        _TableMapping = [(NSDictionary *)[NSPropertyListSerialization
                                       propertyListFromData:plistXML
                                       mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                       format:&format
                                       errorDescription:&errorDesc] objectForKey:@"FileToTableMapping"];
    }
    return _TableMapping;
}

- (NSURL *)pdfFileURL{
    if (_pdfFileURL == nil) {
        _pdfFileURL = [self.docPrinter toFullPDFWithPath:[self docPathFromFileName]];
    }
    return _pdfFileURL;
}

- (NSURL *)pdfFormatFileURL{
    if (_pdfFormatFileURL == nil) {
//        if (self.pdfFileURL) {
//            _pdfFormatFileURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@.format.pdf", [self.pdfFileURL absoluteString]]];
//        }
        _pdfFormatFileURL = [self.docPrinter toFormedPDFWithPath:[self docPathFromFileName]];
    }
    return _pdfFormatFileURL;
}

- (NSArray *)docPDFArray{
    if (_docPDFArray == nil) {
        _docPDFArray = [CaseDocuments caseDocumentsForCase:self.caseID docName:self.fileName];
    }
    return _docPDFArray;
}

#pragma mark - viewLoad
- (void)viewDidLoad
{
   
    NSString *imagePath=[[NSBundle mainBundle] pathForResource:@"文书打印-bg" ofType:@"png"];
    self.view.layer.contents=(id)[[UIImage imageWithContentsOfFile:imagePath] CGImage];    
    
    imagePath=[[NSBundle mainBundle] pathForResource:@"蓝底按钮" ofType:@"png"];
    UIImage *buttonImage=[[UIImage imageWithContentsOfFile:imagePath] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [self.uiButtonPrintPreview setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
    imagePath=[[NSBundle mainBundle] pathForResource:@"蓝底主按钮" ofType:@"png"];
    buttonImage=[[UIImage imageWithContentsOfFile:imagePath] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [self.uiButtonPrintFull setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.uiButtonPrintForm setBackgroundImage:buttonImage forState:UIControlStateNormal];

    [self.pdfView.layer setCornerRadius:4.0f];
    [self.pdfView.layer setMasksToBounds:YES];
    
    self.navigationItem.title=self.fileName;

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];  
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    self.docIndex = 0;
    [self.uiButtonPreDoc setEnabled:NO];
    [self.uiButtonPreDoc setAlpha:0.7];
    
    if (self.docPrinterState==kPDFView) {
        [self.editorView removeFromSuperview];
        [self.pageControl removeFromSuperview];
        [self.uiButtonPrintPreview removeFromSuperview];
        [self.uiButtonReDefault removeFromSuperview];
        [self.uiButtonDeleteDoc removeFromSuperview];
        [self setEditorView:nil];
        [self setPageControl:nil];
        [self setUiButtonPrintPreview:nil];
        [self setUiButtonReDefault:nil];
        [self setUiButtonDeleteDoc:nil];
        
        self.docCount = self.docPDFArray.count;
        
        if (self.docPDFArray.count>0) {
            self.pdfFileURL=[NSURL fileURLWithPath:[[self.docPDFArray objectAtIndex:self.docIndex] valueForKey:@"document_path"]];
            [self.pdfView loadRequest:[NSURLRequest requestWithURL:self.pdfFileURL]];
        }
    } else if (self.docPrinterState==kDocEditAndPrint) {
        [self.editorView.layer setCornerRadius:4.0f];
        [self.editorView.layer setMasksToBounds:YES];
        self.editorView.bounces=NO;
        self.editorView.backgroundColor=[UIColor whiteColor];
        self.editorView.opaque=NO;
        
        NSArray *arrayPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path=[arrayPaths objectAtIndex:0];
        NSString *docPath=[NSString stringWithFormat:@"CaseDoc/%@",self.caseID];
        docPath=[path stringByAppendingPathComponent:docPath];
        if (![[NSFileManager defaultManager] fileExistsAtPath:docPath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString *storyboardIdentifier = [self.TableMapping objectForKey:self.fileName];
        if ([[self.TableMapping objectForKey:self.fileName] isEqualToString:@"InquireTable"]){
            [self.uiButtonPrintForm removeFromSuperview];     //删除套打
        }
        if (storyboardIdentifier) {
            self.docPrinter=[self.storyboard instantiateViewControllerWithIdentifier:storyboardIdentifier];
            self.docPrinter.delegate = self;
            self.docPrinter.caseID=self.caseID;
            self.docPrinter.parameters = self.parameters;
            CGRect frame = self.docPrinter.view.frame;
            if (frame.size.width < self.editorView.bounds.size.width) {
                frame.origin.x = self.editorView.bounds.size.width/2 - frame.size.width/2;
                /*
                 self.docPrinter.view.frame = frame;
                 *modify by lxm 2013.05.13
                 */
                self.docPrinter.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
                
            }
            self.docCount = self.docPrinter.dataCount;
            [self.editorView addSubview:self.docPrinter.view];
            self.editorView.contentSize=self.docPrinter.view.frame.size;
            
            if ([self.docPrinter shouldDocDeleted]) {
                [self.uiButtonDeleteDoc setHidden:NO];
            }
            if ([self.docPrinter shouldGenereateDefaultDoc]) {
                [self.uiButtonReDefault setHidden:NO];
            }
        }
        
    }
    if (self.docCount > 1) {
        [self.uiButtonNextDoc setHidden:NO];
        [self.uiButtonPreDoc setHidden:NO];
    }
    newFile=NO;
   
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setEditorView:nil];
    [self setPdfView:nil];
    [self setCaseID:nil];
    [self setFileName:nil];
    [self setDocReloadDelegate:nil];
    [self setDocPrinter:nil];
    [self setUiButtonPrintPreview:nil];
    [self setUiButtonPrintFull:nil];
    [self setUiButtonPrintForm:nil];
    [self setPageControl:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


-(void)viewWillDisappear:(BOOL)animated{
    if (self.docPrinterState==kDocEditAndPrint && ![self.caseID isEmpty] && newFile) {
        [self.docReloadDelegate reloadDocuments];
    }    
}

#pragma mark - IBActions
- (IBAction)pageSave:(id)sender {
    [self.docPrinter pageSaveInfo];
}

-(IBAction)pageControl:(id)sender{
    if ([sender currentPage] == 0) {
        [UIView transitionWithView:self.editorView duration:0.5
                           options:UIViewAnimationOptionTransitionCurlDown
                        animations:^ { [self.view bringSubviewToFront:self.editorView]; }
                        completion:nil];
        NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]];
        [self.pdfView loadRequest:request];
    } else {
        self.pdfFileURL=[self.docPrinter toFullPDFWithPath:[self docPathFromFileName]];
        [UIView transitionWithView:self.pdfView duration:0.5
                           options:UIViewAnimationOptionTransitionCurlUp
                        animations:^ { [self.view bringSubviewToFront:self.pdfView]; }
                        completion:nil];
        NSURLRequest *request=[NSURLRequest requestWithURL:self.pdfFileURL];
        [self.pdfView setScalesPageToFit:YES];
        [self.pdfView loadRequest:request];
    }
}

//套打
-(IBAction)btnPrintFormedPDF:(id)sender{
    
    
    [self.docPrinter toFormedPDFWithPath:[self docPathFromFileName]];

    NSLog(@"the URL of the PDF is ------%@",[self.docPrinter toFormedPDFWithPath:[self docPathFromFileName]]);
    
    [self printPDF:PDFWithoutTable withSender:sender];


}

//普通表格全打印
-(IBAction)btnPrintFullPDF:(id)sender{
    [self.docPrinter toFullPDFWithPath:[self docPathFromFileName]];
    [self printPDF:PDFWithTable withSender:sender];
}


- (void) printPDF:(PDFType *)fileType withSender:(id)sender{
    NSURL *file = nil;
    
    if (fileType == PDFWithTable) {
        file = self.pdfFileURL;
    }else{
        file = self.pdfFormatFileURL;
    }
    if (file != nil) {
        if ([UIPrintInteractionController isPrintingAvailable]) {
            NSData *fileData = [NSData dataWithContentsOfURL:file];
            if ([UIPrintInteractionController canPrintData:fileData]) {
                UIPrintInteractionController * printer=[UIPrintInteractionController sharedPrintController];
                [printer setDelegate:self];
               
                if (self.docPrinterState==kDocEditAndPrint) {
                    newFile=YES;
                    if (![CaseDocuments isExistingDocumentForCase:self.caseID docPath:self.docPathFromFileName]) {
                        NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
                        NSEntityDescription *entity=[NSEntityDescription entityForName:@"CaseDocuments" inManagedObjectContext:context];
                        CaseDocuments *newDoc=[[CaseDocuments alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
                        newDoc.caseinfo_id=self.caseID;
                        newDoc.document_name=self.fileName;
                        newDoc.document_path=self.docPathFromFileName;
                    }
                }
                
                printer.printingItem = fileData;
                [self setDefaultPrintInfoForPrinter:printer];
                
                void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
                ^(UIPrintInteractionController *printController, BOOL completed, NSError *error ) {
                    if (!completed && error) {
                        NSLog(@"Printing could not complete because of error: %@", [error localizedDescription]);
                    }
                };
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    [printer presentFromRect:[sender frame] inView:self.view animated:YES completionHandler:completionHandler];
                } else {
                    [printer presentAnimated:YES completionHandler:completionHandler];
                }
            }
        } else {
            NSLog(@"AirPrinter NOT Available");
        }
    }
}

/*
//更新文档格式按钮
- (IBAction)btnUpdateDocumentXMLSettingFiles:(id)sender {
    NSString *tableName=[self.TableMapping valueForKey:self.fileName];
    [self updateDocumentsSettingFiles:tableName];
    self.pdfFileURL=[self.docPrinter toFullPDFWithTable:[self docPathFromFileName]];
    NSURLRequest *request=[NSURLRequest requestWithURL:self.pdfFileURL];
    [self.pdfView setScalesPageToFit:YES];
    [self.pdfView loadRequest:request];
}
*/

//打印预览按钮po
- (IBAction)btnPrintPreview:(id)sender {
    if (self.pageControl.currentPage == 1) {
        [UIView transitionWithView:self.editorView duration:0.5
                           options:UIViewAnimationOptionTransitionCurlDown
                        animations:^ { [self.view bringSubviewToFront:self.editorView]; }
                        completion:nil];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationCurveEaseInOut
                         animations:^{ [(UIButton *)sender setTitle:@"打印预览" forState:UIControlStateNormal]; }
                         completion:nil];
        NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]];
        [self.pdfView loadRequest:request];
        [self.pageControl setCurrentPage:0];
        [self.pageControl updateCurrentPageDisplay];
    } else {
        [UIView transitionWithView:self.pdfView duration:0.5
                           options:UIViewAnimationOptionTransitionCurlUp
                        animations:^ { [self.view bringSubviewToFront:self.pdfView]; }
                        completion:nil];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationCurveEaseInOut
                         animations:^{ [(UIButton *)sender setTitle:@"返回编辑" forState:UIControlStateNormal]; }
                         completion:nil];
        self.pdfFileURL=[self.docPrinter toFullPDFWithPath:[self docPathFromFileName]];
        NSLog(@"%@", self.pdfFileURL);
        NSURLRequest *request=[NSURLRequest requestWithURL:self.pdfFileURL];
        
        NSLog(@"++++%@", [[NSBundle mainBundle]pathForResource:@"DocTemplates" ofType:nil]);
        
        [self.pdfView setScalesPageToFit:YES];
        [self.pdfView loadRequest:request];
        [self.pageControl setCurrentPage:1];
        [self.pageControl updateCurrentPageDisplay];
    }
    
    if (self.docReloadDelegate) {
        [self.docReloadDelegate setCaseIDdelegate2:self.caseID];
    }
}



- (IBAction)btnPreDoc:(UIButton *)sender {
    self.docIndex -= 1;
    if (self.docIndex <= 0) {
        [sender setAlpha:0.7];
        [sender setEnabled:NO];
        self.docIndex = 0;
    }
    if (self.docPrinterState == kPDFView) {
        self.pdfFileURL=[NSURL fileURLWithPath:[[self.docPDFArray objectAtIndex:self.docIndex] valueForKey:@"document_path"]];
        [self.pdfView loadRequest:[NSURLRequest requestWithURL:self.pdfFileURL]];
    } else if (self.docPrinterState == kDocEditAndPrint) {
        [self.docPrinter loadDataAtIndex:self.docIndex];
        if (self.pageControl.currentPage == 1) {
            self.pdfFileURL = [self.docPrinter toFullPDFWithPath:[self docPathFromFileName]];
            [self.pdfView loadRequest:[NSURLRequest requestWithURL:self.pdfFileURL]];
        }
    }
    if (self.uiButtonNextDoc.enabled == NO){
        [self.uiButtonNextDoc setEnabled:YES];
        [self.uiButtonNextDoc setAlpha:1.0];
    }
}

- (IBAction)btnNextDoc:(UIButton *)sender {
    self.docIndex += 1;
    if (self.docIndex >= self.docCount -1) {
        [sender setAlpha:0.7];
        [sender setEnabled:NO];
        self.docIndex = self.docCount - 1;
    }
    if (self.docPrinterState == kPDFView) {
        self.pdfFileURL=[NSURL fileURLWithPath:[[self.docPDFArray objectAtIndex:self.docIndex] valueForKey:@"document_path"]];
        [self.pdfView loadRequest:[NSURLRequest requestWithURL:self.pdfFileURL]];
    } else if (self.docPrinterState == kDocEditAndPrint) {
        [self.docPrinter loadDataAtIndex:self.docIndex];
        if (self.pageControl.currentPage == 1) {
            self.pdfFileURL = [self.docPrinter toFullPDFWithPath:[self docPathFromFileName]];
            [self.pdfView loadRequest:[NSURLRequest requestWithURL:self.pdfFileURL]];
        }
    }
    if (self.uiButtonPreDoc.enabled == NO) {
        [self.uiButtonPreDoc setEnabled:YES];
        [self.uiButtonPreDoc setAlpha:1.0];
    }
}

- (IBAction)btnRegenerateDefaultInfo:(id)sender {
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"是否根据案件情况重新生成文书默认值?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = ReDefaultDocAlertTag;
    [alert show];
}

- (IBAction)btnDeleteDoc:(id)sender {
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"警告" message:@"将删除当前文书并返回案件信息页面，是否继续?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = DeleteDocAlertTag;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertView.tag == ReDefaultDocAlertTag ){
        if (buttonIndex == 1) {
            [self.docPrinter generateDefaultAndLoad];
        }
    } else if (alertView.tag == DeleteDocAlertTag){
        if (buttonIndex == 1) {
            [self.docPrinter deleteCurrentDoc];
            newFile=YES;
            [CaseDocuments deleteDocumentsForCase:self.caseID docName:self.fileName];
            NSString *pathString = [self docPathFromFileName];
            if ([[NSFileManager defaultManager] fileExistsAtPath:pathString]) {
                [[NSFileManager defaultManager] removeItemAtPath:pathString error:nil];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - Keyboard Event
//软键盘弹出后，增加scrollview的长度，防止遮挡
-(void)keyboardWillShow:(NSNotification *)aNotification{
    CGSize orSize=self.editorView.contentSize;
    CGRect keyboardEndFrame;
    NSDictionary* userInfo = [aNotification userInfo];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    self.editorView.contentSize=CGSizeMake(orSize.width, orSize.height + keyboardEndFrame.size.width + 5);
}

//软键盘消失，恢复scrollview正常长度
-(void)keyboardWillHide:(NSNotification *)aNotification{
    self.editorView.contentSize=self.docPrinter.view.frame.size;
}

#pragma mark - methods
//从当前文件名及案号生成对应的文档路径
-(NSString *)docPathFromFileName{
    if (![self.caseID isEmpty] || [self.fileName isEqualToString:@"施工整改通知书"]) {
        NSString *fileName=[NSString stringWithFormat:@"CaseDoc/%@/%@-%d.pdf",self.caseID,self.fileName,self.docIndex];
        NSArray *arrayPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path=[arrayPaths objectAtIndex:0];
        return [path stringByAppendingPathComponent:fileName];
    } else {
        return @"";
    }
}
    
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
}


#pragma mark -UIPrintInteractionControllerDelegate
- (UIPrintPaper *)printInteractionController:(UIPrintInteractionController *)printInteractionController choosePaper:(NSArray *)paperList {
    
    CGSize paperSize = self.docPrinter.printController.pdfRenderer.pdfInfo.mediaBox.size;
    UIPrintPaper *printPaper = [UIPrintPaper bestPaperForPageSize:paperSize withPapersFromArray:paperList];
    NSLog(@"Choosed UIPrintPaper: { paperSize: %@, printableRect: %@ }", NSStringFromCGSize(printPaper.paperSize), NSStringFromCGRect(printPaper.printableRect));
    return printPaper;
}

- (void)printInteractionControllerDidPresentPrinterOptions:(UIPrintInteractionController *)printInteractionController
{
    [self setDefaultPrintInfoForPrinter:printInteractionController];
}

- (void)setDefaultPrintInfoForPrinter:(UIPrintInteractionController *)printInteractionController
{
    
    NSLog(@"printerID: %@",printInteractionController.printInfo.printerID);
    UIPrintInfo *printInfo=[UIPrintInfo printInfo];
    printInfo.jobName = self.fileName;
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.orientation = UIPrintInfoOrientationPortrait;
    printInfo.duplex = UIPrintInfoDuplexNone;
    [printInfo setValue:[NSNumber numberWithBool:YES] forKey:@"scaleUp"];
    printInteractionController.printInfo = printInfo;
}
- (IBAction)saveBarButtonPressed:(id)sender {
    if (![self.caseID isEmpty] && self.docPrinterState == kDocEditAndPrint &&
        self.pageControl.currentPage == 0) {
        
        CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
        if (caseInfo.isuploaded.boolValue == NO) {
            [self.docPrinter pageSaveInfo];
            [self.docPrinter.view endEditing:YES];
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"已保存" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"已上传案件，不能修改" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }
        
        if (self.docReloadDelegate) {
            [self.docReloadDelegate setCaseIDdelegate2:self.caseID];
        }
        
    }
    
}



- (void)moveViewAboveKeyboardInScrollView:(UIView*)view{
    svos = self.editorView.contentOffset;
    CGPoint pt;
    CGRect rc = [view bounds];
    rc = [view convertRect:rc toView:self.editorView];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 60;
    [self.editorView setContentOffset:pt animated:YES];
}

- (void)reboundViewInScrollView:(UIView*)view{
    [self.editorView setContentOffset:svos animated:YES];
    [view resignFirstResponder];
}
//implementation
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self moveViewAboveKeyboardInScrollView:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self reboundViewInScrollView:textField];
}


- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self moveViewAboveKeyboardInScrollView:textView];
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    [self reboundViewInScrollView:textView];
}
@end
