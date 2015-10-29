@import UIKit;

@interface CoverVerticalPresentTransition : NSObject<UIViewControllerAnimatedTransitioning> @end
@interface CrossDissolvePresentTransition : NSObject<UIViewControllerAnimatedTransitioning> @end

@interface DismissTransition : NSObject <UIViewControllerAnimatedTransitioning>
-(instancetype)initWithModalTransitionStyle:(UIModalTransitionStyle)style;
@property BOOL isInteractiveTransition;
@end



#import "NNPanGestureDismissableViewControllerEngine.h"
#import "NBULogStub.h"



@implementation NNPanGestureDismissableViewControllerEngine{
	__weak UIViewController* _vc;
	UIPercentDrivenInteractiveTransition* _interactiveTransition;
    UIGestureRecognizer* _scrollViewDisabledGestureRecognizer;
    DismissTransition* _closeAnimator;
}

-(instancetype)initWithViewController:(UIViewController*)viewController{
	if( self = [super init] ) {
		_vc = viewController;
		_vc.transitioningDelegate = self;
	}
	return self;
}




-(void)addGestureRecognizer{
	UIPanGestureRecognizer* gr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    gr.delegate = self;
	[_vc.view addGestureRecognizer:gr];
}


-(void)onPan:(UIPanGestureRecognizer*)recognizer{
	if( recognizer.state == UIGestureRecognizerStateBegan ){
		_interactiveTransition = [UIPercentDrivenInteractiveTransition new];
		[_vc dismissViewControllerAnimated:YES completion:nil];
	} else if (recognizer.state == UIGestureRecognizerStateChanged) {
		CGPoint point = [recognizer translationInView:_vc.view];
		CGFloat progress = point.y / _vc.view.bounds.size.height;
		[_interactiveTransition updateInteractiveTransition:progress];
	} else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
		CGPoint velocity = [recognizer velocityInView:_vc.view];
		if( velocity.y > 500 ){
            _interactiveTransition.completionSpeed = 1;
            _interactiveTransition.completionCurve = UIViewAnimationCurveEaseOut;
			[_interactiveTransition finishInteractiveTransition];
		} else {
            _interactiveTransition.completionSpeed = 0.33;
            _interactiveTransition.completionCurve = UIViewAnimationCurveEaseInOut;
			[_interactiveTransition cancelInteractiveTransition];
            _scrollViewDisabledGestureRecognizer.enabled = YES;
		}
		_interactiveTransition = nil;
	}
}



#pragma mark - GestureRecognizer Delegate

- (BOOL)gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    /// UITableViewWrapperView とか余計なシステムクラスが入ってくるので、isMemberOfClassを使って厳格に判定
    if( [otherGestureRecognizer.view isMemberOfClass:[UIScrollView class]] || [otherGestureRecognizer.view isMemberOfClass:[UITableView class]] ){
        UIScrollView* tableView = (UIScrollView*)otherGestureRecognizer.view;
        if( tableView.contentOffset.y <= -tableView.contentInset.top ){
//            NBULogInfo(@"scrollViewのトップにいます");
            CGPoint velocity = [gestureRecognizer velocityInView:_vc.view];
            if( velocity.y >= 0 ){
                otherGestureRecognizer.enabled = NO;
                _scrollViewDisabledGestureRecognizer = otherGestureRecognizer;
            }
        }
    }
    return NO;
}



#pragma mark - Transition Delegate

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    switch (_vc.modalTransitionStyle) {
        case UIModalTransitionStyleCrossDissolve:
            return [CrossDissolvePresentTransition new];
        default:
           return [CoverVerticalPresentTransition new];
    }
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    _closeAnimator = [[DismissTransition alloc] initWithModalTransitionStyle:_vc.modalTransitionStyle];
	return _closeAnimator;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
    if( _interactiveTransition ){
        _closeAnimator.isInteractiveTransition = YES;
    } else {
        _closeAnimator.isInteractiveTransition = NO;
    }
	return _interactiveTransition;
}

@end










#pragma mark -




@implementation CrossDissolvePresentTransition

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.25;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:toVC.view];
    toVC.view.alpha = 0;
    toVC.view.frame = fromVC.view.frame;
    
    /// UIModalPresentationCustom の場合、遷移元のviewWillDisappearが呼ばれないので呼ぶ
    if( toVC.modalPresentationStyle == UIModalPresentationCustom ){
        [fromVC beginAppearanceTransition:NO animated:YES];
    }

    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:(7<<16) animations:^{
       toVC.view.alpha = 1;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
        
        /// UIModalPresentationCustom の場合、遷移元のviewDidDisappearが呼ばれないので呼ぶ。順番は[transitionContext completeTransition]のあと
        if( toVC.modalPresentationStyle == UIModalPresentationCustom ){
            [fromVC endAppearanceTransition];
        }
    }];
}

@end







@implementation CoverVerticalPresentTransition

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.25;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:toVC.view];
    CGRect targetFrame = toVC.view.frame;
    
    CGRect initFrame = targetFrame;
    initFrame.origin.y = [UIScreen mainScreen].bounds.size.height;
    toVC.view.frame = initFrame;
    
    /// UIModalPresentationCustom の場合、遷移元のviewWillDisappearが呼ばれないので呼ぶ
    if( toVC.modalPresentationStyle == UIModalPresentationCustom ){
        [fromVC beginAppearanceTransition:NO animated:YES];
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:(7<<16) animations:^{
        toVC.view.frame = targetFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
        
        /// UIModalPresentationCustom の場合、遷移元のviewDidDisappearが呼ばれないので呼ぶ。順番は[transitionContext completeTransition]のあと
        if( toVC.modalPresentationStyle == UIModalPresentationCustom ){
            [fromVC endAppearanceTransition];
        }
    }];
}

@end








@implementation DismissTransition{
    UIModalTransitionStyle _style;
}

-(instancetype)initWithModalTransitionStyle:(UIModalTransitionStyle)style{
    if( self = [super init] ){
        _style = style;
    }
    return self;
}


- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.25;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    /// パンによるdismissなら、かならずverticalTransitionにする
    if( _isInteractiveTransition ){
         [self animateVerticalTransition:transitionContext];
        return;
    }
    
    switch (_style) {
        case UIModalTransitionStyleCrossDissolve:
            [self animateCrossDissolveTransition:transitionContext];
            break;
        default:
            [self animateVerticalTransition:transitionContext];
            break;
    }
}

- (void)animateVerticalTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    /// 通常のモーダルの場合は、閉じるときに後ろにもとのVCを表示しておく
    /// (逆に、透過モーダルの場合はinsertするとおかしくなります)
    if( fromVC.modalPresentationStyle == UIModalPresentationFullScreen ){
        [containerView insertSubview:toVC.view atIndex:0];
    }
    
    /// UIModalPresentationCustom の場合、遷移先のviewWillAppearが呼ばれないので呼ぶ
    if( fromVC.modalPresentationStyle == UIModalPresentationCustom ){
        [toVC beginAppearanceTransition:YES animated:YES];
    }
    
    CGRect targetFrame = fromVC.view.frame;
    targetFrame.origin.y = [UIScreen mainScreen].bounds.size.height;
    
    /// interactive transition なら、ドラッグに直線的に追従するように、イージングさせない
    UIViewAnimationOptions options;
    if( _isInteractiveTransition ){
        options = UIViewAnimationOptionCurveLinear;
    } else {
        options = (7<<16);
    }
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        fromVC.view.frame = targetFrame;
    } completion:^(BOOL finished) {
        /// UIModalPresentationCustom で途中でdismissをキャンセルした場合は遷移先のviewWillDisappearを呼ぶ
        if( transitionContext.transitionWasCancelled && fromVC.modalPresentationStyle == UIModalPresentationCustom ){
            [toVC beginAppearanceTransition:NO animated:YES];
        }
        
        /// UIModalPresentationCustom の場合、遷移先のviewDidAppear(キャンセルの場合はviewDidDisappear)が呼ばれないので呼ぶ。順番は[transitionContext completeTransition]の前
        if( fromVC.modalPresentationStyle == UIModalPresentationCustom ){
            [toVC endAppearanceTransition];
        }
        
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}



- (void)animateCrossDissolveTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    /// 通常のモーダルの場合は、閉じるときに後ろにもとのVCを表示しておく
    /// (逆に、透過モーダルの場合はinsertするとおかしくなります)
    if( fromVC.modalPresentationStyle == UIModalPresentationFullScreen ){
        [containerView insertSubview:toVC.view atIndex:0];
    }
    
    /// UIModalPresentationCustom の場合、遷移先のviewWillAppearが呼ばれないので呼ぶ
    if( fromVC.modalPresentationStyle == UIModalPresentationCustom ){
        [toVC beginAppearanceTransition:YES animated:YES];
    }
    
    [UIView animateWithDuration:0 delay:0 options:(7<<16) animations:^{
        fromVC.view.alpha = 0;
    } completion:^(BOOL finished) {
        /// UIModalPresentationCustom の場合、遷移先のviewDidAppearが呼ばれないので呼ぶ。順番は[transitionContext completeTransition]の前
        if( fromVC.modalPresentationStyle == UIModalPresentationCustom ){
            [toVC endAppearanceTransition];
        }
        
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}


@end











