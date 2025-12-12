//
//  MailGenerate.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 12.12.2025.
//

import UIKit

enum MailGenerate {
    static func pdfURL(participient: Participient) -> URL? {
        let pageWidth: CGFloat = 390
        let paddingX: CGFloat = 16
        let contentWidth = pageWidth - paddingX * 2
        
        let topTitle: NSAttributedString = {
            let attrs = TextAttributes()
                .textColor(Appearance.main400)
                .font(Fonts.NewYork.mediumBold(size: 20))
                .lineHeight(24)
                .textAlignment(.center)
            return "Share.AppName".localized.attributed(with: attrs)
        }()
        
        let assigned: NSAttributedString = {
            let attrs = TextAttributes()
                .textColor(Appearance.main400)
                .font(Fonts.SFPro.medium(size: 16))
                .lineHeight(24)
                .textAlignment(.center)
            return "Share.Assigned".localized.attributed(with: attrs)
        }()
        
        let name: NSAttributedString = {
            let attrs = TextAttributes()
                .textColor(Appearance.mono200)
                .font(Fonts.NewYork.mediumBold(size: 32))
                .lineHeight(44)
                .textAlignment(.center)
            return participient.name.attributed(with: attrs)
        }()
        
        let info: NSAttributedString = {
            let attrs = TextAttributes()
                .textColor(UIColor(integralRed: 102, green: 112, blue: 133))
                .font(Fonts.SFPro.regular(size: 15))
                .lineHeight(24)
                .textAlignment(.center)
            return "Share.Info".localized.attributed(with: attrs)
        }()
        
        let footerTitle: NSAttributedString = {
            let attrs = TextAttributes()
                .textColor(Appearance.main400)
                .font(Fonts.NewYork.mediumBold(size: 20))
                .lineHeight(24)
                .textAlignment(.left)
            return "Share.AppName".localized.attributed(with: attrs)
        }()
        
        let footerEmail: NSAttributedString = {
            let attrs = TextAttributes()
                .textColor(UIColor(integralRed: 102, green: 112, blue: 133))
                .font(Fonts.SFPro.regular(size: 15))
                .lineHeight(24)
                .textAlignment(.left)
            return GlobalDefinitions.developerEmail.attributed(with: attrs)
        }()
        
        let mainImage = UIImage(named: "Share.Image")
        let storeButton = UIImage(named: "Share.AppStore")
        
        var y: CGFloat = 24
        
        y = y + topTitle.boundingHeight(constrainedToWidth: contentWidth)
        y += 20
        
        if let img = mainImage {
            let targetW = contentWidth
            let ratio = img.size.height / max(img.size.width, 1)
            y += targetW * ratio
        }
        y += 28
        
        y += assigned.boundingHeight(constrainedToWidth: contentWidth)
        y += 10
        
        y += name.boundingHeight(constrainedToWidth: contentWidth)
        y += 14
        
        y += info.boundingHeight(constrainedToWidth: contentWidth)
        y += 20
        
        var buttonRect = CGRect.zero
        if let btn = storeButton {
            let buttonW: CGFloat = min(160, contentWidth)
            let ratio = btn.size.height / max(btn.size.width, 1)
            let buttonH = buttonW * ratio
            buttonRect = CGRect(
                x: (pageWidth - buttonW) / 2,
                y: y,
                width: buttonW,
                height: buttonH
            ).integral
            y = buttonRect.maxY
        }
        
        y += 32
        
        let line1Y = y
        let line2Y = y + 12
        y = line2Y + 14
        
        y += footerTitle.boundingHeight(constrainedToWidth: contentWidth)
        y += 6
        y += footerEmail.boundingHeight(constrainedToWidth: contentWidth)
        y += 18
        
        let pageSize = CGSize(width: pageWidth, height: y)
        
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize))
        let data = renderer.pdfData { ctx in
            ctx.beginPage()
            
            UIColor.white.setFill()
            ctx.fill(CGRect(origin: .zero, size: pageSize))
            
            var y: CGFloat = 24
            
            y = drawCentered(topTitle, in: ctx, x: paddingX, y: y, width: contentWidth)
            y += 20
            
            if let img = mainImage {
                let targetW = contentWidth
                let ratio = img.size.height / max(img.size.width, 1)
                let targetH = targetW * ratio
                let rect = CGRect(x: paddingX, y: y, width: targetW, height: targetH).integral
                img.draw(in: rect)
                y = rect.maxY
            }
            y += 28
            
            y = drawCentered(assigned, in: ctx, x: paddingX, y: y, width: contentWidth)
            y += 10
            
            y = drawCentered(name, in: ctx, x: paddingX, y: y, width: contentWidth)
            y += 14
            
            y = drawCentered(info, in: ctx, x: paddingX, y: y, width: contentWidth)
            y += 20
            
            if let btn = storeButton, !buttonRect.isEmpty {
                btn.draw(in: buttonRect)
                
                let pdfButtonRect = CGRect(
                    x: buttonRect.minX,
                    y: pageSize.height - buttonRect.maxY,
                    width: buttonRect.width,
                    height: buttonRect.height
                ).integral

                ctx.setURL(GlobalDefinitions.appStoreUrl, for: pdfButtonRect)
                y = buttonRect.maxY
            }
            
            y += 32
            
            let dividerColor = UIColor(integralRed: 224, green: 224, blue: 224)
            let cg = ctx.cgContext
            dividerColor.setStroke()
            
            let lineHeight: CGFloat = 1.0
            cg.setLineWidth(lineHeight)
            
            cg.move(to: CGPoint(x: paddingX, y: line1Y))
            cg.addLine(to: CGPoint(x: pageWidth - paddingX, y: line1Y))
            cg.strokePath()
            
            cg.move(to: CGPoint(x: paddingX, y: line2Y))
            cg.addLine(to: CGPoint(x: pageWidth - paddingX, y: line2Y))
            cg.strokePath()
            
            y = line2Y + 14
            
            y = drawLeft(footerTitle, in: ctx, x: paddingX, y: y, width: contentWidth)
            y += 6
            
            _ = drawLeft(footerEmail, in: ctx, x: paddingX, y: y, width: contentWidth)
        }
        
        let filename = "SecretSanta_\(participient.id).pdf"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        
        do {
            try data.write(to: url, options: .atomic)
            return url
        } catch {
            return nil
        }
    }
}

// MARK: - Helpers

private func drawCentered(
    _ attributed: NSAttributedString,
    in ctx: UIGraphicsPDFRendererContext,
    x: CGFloat,
    y: CGFloat,
    width: CGFloat
) -> CGFloat {
    let rect = attributed.boundingRect(
        with: CGSize(width: width, height: .greatestFiniteMagnitude),
        options: [.usesLineFragmentOrigin, .usesFontLeading],
        context: nil
    ).integral

    let drawRect = CGRect(x: x, y: y, width: width, height: rect.height).integral
    attributed.draw(in: drawRect)
    return drawRect.maxY
}

private extension NSAttributedString {
    func boundingHeight(constrainedToWidth width: CGFloat) -> CGFloat {
        let rect = boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )
        return ceil(rect.height)
    }
}

private func drawLeft(
    _ attributed: NSAttributedString,
    in ctx: UIGraphicsPDFRendererContext,
    x: CGFloat,
    y: CGFloat,
    width: CGFloat
) -> CGFloat {
    let rect = attributed.boundingRect(
        with: CGSize(width: width, height: .greatestFiniteMagnitude),
        options: [.usesLineFragmentOrigin, .usesFontLeading],
        context: nil
    ).integral

    let drawRect = CGRect(x: x, y: y, width: width, height: rect.height).integral
    attributed.draw(in: drawRect)
    return drawRect.maxY
}
