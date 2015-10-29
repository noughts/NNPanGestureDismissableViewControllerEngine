@import UIKit;
@interface OpenAnimator : NSObject<UIViewControllerAnimatedTransitioning>
@end


@import UIKit;
@interface CloseAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@property BOOL isInteractiveTransition;
@end



#import "NNPanGestureDismissableViewControllerEngine.h"
#import "NBULogStub.h"



@implementation NNPanGestureDismissableViewControllerEngine{
	UIViewController* _vc;
	UIPercentDrivenInteractiveTransition* _interactiveTransition;
    UIGestureRecognizer* _scrollViewDisabledGestureRecognizer;
    CloseAnimator* _closeAnimator;
}

-(instancetype)initWithViewController:(UIViewController*)viewController{
	if( self = [super init] ) {
		_vc = viewController;
		_vc.modalPresentationStyle = UIModalPresentationCustom;
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
	return [OpenAnimator new];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    _closeAnimator = [CloseAnimator new];
	return _closeAnimator;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator{
	return nil;
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






@implementation OpenAnimator

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.25;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    //	UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:toVC.view];
    CGRect targetFrame = toVC.view.frame;
    
    CGRect initFrame = targetFrame;
    initFrame.origin.y = [UIScreen mainScreen].bounds.size.height;
    toVC.view.frame = initFrame;
    

    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:(7<<16) animations:^{
        toVC.view.frame = targetFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end








@implementation CloseAnimator


- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.25;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    //	UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //	UIView *containerView = [transitionContext containerView];
    
    
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
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}


@end










