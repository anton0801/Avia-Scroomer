import Foundation
import SpriteKit
import SwiftUI

class ScroomerGameScene: SKScene, SKPhysicsContactDelegate {
    
    var plane: SKSpriteNode!
    var cannon: SKSpriteNode!
    let radius: CGFloat = 270
    let numOfCoins = 26
    var coinTexture: SKTexture!
    
    var audioEnabled = UserDefaults.standard.bool(forKey: "is_audio_enabled")
    
    var clockwiseDirection = true
    var lastPoint: CGPoint?
    
    private var pauseBtn: SKSpriteNode!
    
    private var timeLabel: SKLabelNode!
    private var creditsLabel: SKLabelNode!
    
    private var pauseLabel: SKSpriteNode!
    
    private var closePauseBtn: SKSpriteNode!
    private var restartGameBtn: SKSpriteNode!
    
    private var cannonTimer = Timer()
    private var gameTimer = Timer()
    private var gameTime = 120 {
        didSet {
            let formattedTime = secondsToMinutesSeconds(seconds: gameTime)
            timeLabel.text = "\(formattedTime.0):\(formattedTime.1)"
            if gameTime == 0 {
                NotificationCenter.default.post(name: Notification.Name("WIN_ROUND"), object: nil, userInfo: ["credits": credits])
            }
        }
    }
    
    private var coinsCount = 26 {
        didSet {
            if coinsCount == 0 {
                addCoins()
            }
        }
    }
    
    private var credits = 0 {
        didSet {
            creditsLabel.text = "\(credits)"
        }
    }
    
    func secondsToMinutesSeconds(seconds: Int) -> (Int, Int) {
        return (seconds / 60, seconds % 60)
    }
    
    override func didMove(to view: SKView) {
        size = CGSize(width: 750, height: 1335)
        physicsWorld.contactDelegate = self
        addBackground()
        
        plane = SKSpriteNode(imageNamed: UserDefaults.standard.string(forKey: "plane") ?? "plane")
        
        coinTexture = SKTexture(imageNamed: "coin")
        
        addCircle()
        addCoins()
        addPlane()
        addCannon()
        addUI()
        movePlaneClockwise(from: plane.position)
        rotateCannon()
        
        gameTimer = .scheduledTimer(timeInterval: 1, target: self, selector: #selector(gameTimePass), userInfo: nil, repeats: true)
        cannonTimer = .scheduledTimer(timeInterval: 1, target: self, selector: #selector(fireCannon), userInfo: nil, repeats: true)
    }
    
    @objc func gameTimePass() {
        if !isPaused {
            gameTime -= 1
        }
    }
    
    private func addUI() {
        pauseBtn = SKSpriteNode(imageNamed: "pause_btn")
        pauseBtn.position = CGPoint(x: 60, y: size.height - 140)
        pauseBtn.size = CGSize(width: 80, height: 70)
        addChild(pauseBtn)
        
        let timeLabelBack = SKSpriteNode(imageNamed: "value_bg")
        timeLabelBack.position = CGPoint(x: 280, y: size.height - 140)
        timeLabelBack.size = CGSize(width: 240, height: 70)
        addChild(timeLabelBack)
        
        timeLabel = SKLabelNode(text: "02:00")
        timeLabel.fontName = "Rubik-Bold"
        timeLabel.fontColor = .black
        timeLabel.fontSize = 28
        timeLabel.position = CGPoint(x: 280, y: size.height - 150)
        addChild(timeLabel)
        
        let creditsBack = SKSpriteNode(imageNamed: "value_bg")
        creditsBack.position = CGPoint(x: 580, y: size.height - 140)
        creditsBack.size = CGSize(width: 240, height: 70)
        addChild(creditsBack)
        
        creditsLabel = SKLabelNode(text: "0")
        creditsLabel.fontName = "Rubik-Bold"
        creditsLabel.fontColor = .black
        creditsLabel.fontSize = 28
        creditsLabel.position = CGPoint(x: 580, y: size.height - 150)
        
        addChild(creditsLabel)
        
        closePauseBtn = SKSpriteNode(imageNamed: "close_btn")
        closePauseBtn.position = CGPoint(x: 60, y: size.height - 140)
        closePauseBtn.size = CGSize(width: 80, height: 70)
        
        restartGameBtn = SKSpriteNode(imageNamed: "replay_btn")
        restartGameBtn.position = CGPoint(x: 60, y: size.height - 230)
        restartGameBtn.size = CGSize(width: 80, height: 70)
        
        pauseLabel = SKSpriteNode(imageNamed: "pause")
        pauseLabel.position = CGPoint(x: size.width / 2, y: size.height - 300)
        pauseLabel.size = CGSize(width: 200, height: 50)
        
        let conditions = SKLabelNode(text: "CONDITIONS:")
        conditions.fontName = "Rubik-Bold"
        conditions.fontColor = .white
        conditions.fontSize = 28
        conditions.position = CGPoint(x: size.width / 2, y: size.height / 2 - 350)
        
        addChild(conditions)
        
        let conditionsText = SKLabelNode(text: "None")
        conditionsText.fontName = "Rubik-Regular"
        conditionsText.fontColor = .white
        conditionsText.fontSize = 28
        conditionsText.position = CGPoint(x: size.width / 2, y: size.height / 2 - 390)
        
        addChild(conditionsText)
    }
    
    private func addCannon() {
        cannon = SKSpriteNode(imageNamed: "cannon")
        cannon.size = CGSize(width: 120, height: 110)
        cannon.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(cannon)
    }
    
    @objc private func fireCannon() {
        if !isPaused {
            let cannonBullet = SKSpriteNode(imageNamed: "cannon_bullet")
            let angle = angle(from: cannon.position, to: plane.position)
            let velocityX = cos(angle) * 300
            let velocityY = sin(angle) * 300
            
            cannonBullet.position.x = cannon.position.x
            cannonBullet.position.y = cannon.position.y + 40
            cannonBullet.size = CGSize(width: 24, height: 22)
            cannonBullet.physicsBody = SKPhysicsBody(circleOfRadius: cannonBullet.size.width / 2)
            cannonBullet.physicsBody?.isDynamic = true
            cannonBullet.physicsBody?.affectedByGravity = false
            cannonBullet.physicsBody?.categoryBitMask = 3
            cannonBullet.physicsBody?.collisionBitMask = 1
            cannonBullet.physicsBody?.contactTestBitMask = 1
            
            cannonBullet.physicsBody?.velocity = CGVector(dx: velocityX, dy: velocityY)
            
            addChild(cannonBullet)
        }
    }
    
    func angle(from point1: CGPoint, to point2: CGPoint) -> CGFloat {
        let deltaX = point2.x - point1.x
        let deltaY = point2.y - point1.y
        return atan2(deltaY, deltaX)
    }
    
    func rotateCannon() {
        let rotateAction = SKAction.run {
            let angle = self.angle(from: self.cannon.position, to: self.plane.position)
            self.cannon.zRotation = angle - 1
        }
        let waitAction = SKAction.wait(forDuration: 0.001)
        let sequence = SKAction.sequence([rotateAction, waitAction])
        let repeatForever = SKAction.repeatForever(sequence)
        self.run(repeatForever)
    }
    
    private func addBackground() {
        let background = SKSpriteNode(imageNamed: "game_back")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(background)
    }
    
    func addCircle() {
        let circle = SKShapeNode(circleOfRadius: radius)
        circle.lineWidth = 30
        circle.strokeColor = .white
        circle.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(circle)
    }
    
    func addCoins() {
        let angleStep = CGFloat.pi * 2 / CGFloat(numOfCoins)
        for i in 0..<numOfCoins {
            let angle = CGFloat(i) * angleStep
            let x = radius * cos(angle)
            let y = radius * sin(angle)
            let coin = SKSpriteNode(texture: coinTexture)
            coin.size = CGSize(width: 20, height: 20)
            coin.position = CGPoint(x: x + frame.midX, y: y + frame.midY)
            coin.physicsBody = SKPhysicsBody(circleOfRadius: coin.size.height / 2)
            coin.physicsBody?.isDynamic = true
            coin.physicsBody?.affectedByGravity = false
            coin.physicsBody?.categoryBitMask = 2
            coin.physicsBody?.collisionBitMask = 1
            coin.physicsBody?.contactTestBitMask = 1
            addChild(coin)
        }
    }
    
    func addPlane() {
        plane.position = CGPoint(x: (frame.midX / 2) + radius - plane.size.width, y: size.height / 2 + radius)
        plane.size = CGSize(width: 70, height: 70)
        plane.physicsBody = SKPhysicsBody(rectangleOf: plane.size)
        plane.name = "plane"
        plane.physicsBody?.isDynamic = false
        plane.physicsBody?.affectedByGravity = false
        plane.physicsBody?.categoryBitMask = 1
        plane.physicsBody?.collisionBitMask = 2 | 3
        plane.physicsBody?.contactTestBitMask = 2 | 3
        addChild(plane)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let object = nodes(at: location)
        
        guard !object.contains(pauseBtn) else {
            showPause()
            return
        }
        
        guard !object.contains(closePauseBtn) else {
            hidePause()
            return
        }
        
        guard !object.contains(restartGameBtn) else {
            restartGame()
            return
        }
        
        
        clockwiseDirection = !clockwiseDirection
        if clockwiseDirection {
            movePlaneClockwise(from: plane.position)
        } else {
            movePlaneAntiClockwise(from: plane.position)
        }
    }
    
    func movePlaneClockwise(from point: CGPoint) {
        plane.removeAllActions()
        let orbitPath = UIBezierPath(arcCenter: CGPoint(x: frame.midX, y: frame.midY), radius: radius, startAngle: angle(from: point), endAngle: angle(from: point) + CGFloat.pi * 2, clockwise: true)
        let orbitAction = SKAction.follow(orbitPath.cgPath, asOffset: false, orientToPath: true, speed: 100)
        plane.run(SKAction.repeatForever(orbitAction))
    }
    
    func movePlaneAntiClockwise(from point: CGPoint) {
        plane.removeAllActions()
        let orbitPath = UIBezierPath(arcCenter: CGPoint(x: frame.midX, y: frame.midY), radius: radius, startAngle: angle(from: point), endAngle: angle(from: point) - CGFloat.pi * 2, clockwise: false)
        let orbitAction = SKAction.follow(orbitPath.cgPath, asOffset: false, orientToPath: true, speed: 100)
        plane.run(SKAction.repeatForever(orbitAction))
    }
    
    func angle(from point: CGPoint) -> CGFloat {
        let deltaX = point.x - frame.midX
        let deltaY = point.y - frame.midY
        return atan2(deltaY, deltaX)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let physicsBody = plane.physicsBody {
            let angle = atan2(physicsBody.velocity.dy, physicsBody.velocity.dx)
            plane.run(SKAction.rotate(toAngle: angle, duration: 0.1))
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if bodyA.categoryBitMask == 1 && bodyB.categoryBitMask == 2 {
            credits += 10
            bodyB.node?.removeFromParent()
            coinsCount -= 1
            if audioEnabled {
                addSound(for: "claim_coin")
            }
        } else if bodyA.categoryBitMask == 1 && bodyB.categoryBitMask == 3 {
            if let fireParticles = SKEmitterNode(fileNamed: "Fire") {
                fireParticles.position = plane.position
                addChild(fireParticles)
                let removeAction = SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.removeFromParent()])
                fireParticles.run(removeAction)
            }
            bodyA.node?.removeFromParent()
            bodyB.node?.removeFromParent()
            if audioEnabled {
                addSound(for: "explosion")
            }
            NotificationCenter.default.post(name: Notification.Name("LOSE_ROUND"), object: nil, userInfo: ["credits": credits])
        }
    }
    
    private func addSound(for file: String) {
        let soundAction = SKAction.playSoundFileNamed(file, waitForCompletion: false)
        run(soundAction)
    }
    
    private func showPause() {
        isPaused = true
        pauseBtn.removeFromParent()
        addChild(closePauseBtn)
        addChild(restartGameBtn)
        addChild(pauseLabel)
    }
    
    private func hidePause() {
        closePauseBtn.removeFromParent()
        restartGameBtn.removeFromParent()
        pauseLabel.removeFromParent()
        addChild(pauseBtn)
        isPaused = false
    }
    
    private func restartGame() {
        let newScene = ScroomerGameScene()
        view?.presentScene(newScene)
    }

}

#Preview {
    VStack {
        SpriteView(scene: ScroomerGameScene())
            .ignoresSafeArea()
    }
}
